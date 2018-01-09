defmodule TimeParser do
  def parse_time(time_string) do
    Timex.parse!(time_string, "{YYYY}-{0M}-{0D}") |> Timex.shift(hours: 5)
  end
end

defmodule SearcherTest do
  alias Jonne.{Searcher, Elasticsearch.MockClient}
  import Mox
  use ExUnit.Case, async: false
  setup :verify_on_exit!

  @current_time TimeParser.parse_time("2016-02-28")
  @current_index "my-index-2016.02.28"

  test "returns nil initial sort if index has no documents" do
    expect_search(payload: initial_search(), result: {:hits, []})

    assert Searcher.get_initial_position(@current_time) == %{
             sort: nil,
             current_index: @current_index
           }
  end

  test "returns initial sort based on the sort order of the latest document" do
    expect_search(payload: initial_search(), result: {:hits, [document_with_sort([100])]})

    assert Searcher.get_initial_position(@current_time) == %{
             sort: [100],
             current_index: @current_index
           }
  end

  test "subsequent search is done without search_after if sort is nil" do
    expect_search(payload: subsequent_search(), result: {:hits, []})

    current_position = %{current_index: @current_index, sort: nil}

    assert Searcher.get_new_messages(@current_time, current_position) == %{
             position: current_position,
             hits: []
           }
  end

  test "subsequent search returns current sort if no new results are found" do
    expect_search(payload: subsequent_search(search_after: [1]), result: {:hits, []})

    current_position = %{current_index: @current_index, sort: [1]}

    assert Searcher.get_new_messages(@current_time, current_position) == %{
             position: current_position,
             hits: []
           }
  end

  test "subsequent search returns new hits and new sort position if results are found" do
    new_document = document_with_sort([2])
    expect_search(payload: subsequent_search(search_after: [1]), result: {:hits, [new_document]})

    current_position = %{current_index: @current_index, sort: [1]}
    result = Searcher.get_new_messages(@current_time, current_position)

    assert result.position == %{current_index: @current_index, sort: [2]}
    assert result.hits == [new_document]
  end

  test "search uses two indices when date changes, and returns the new index in the position" do
    new_documents = [document_with_sort([2]), document_with_sort([3])]

    next_day = TimeParser.parse_time("2016-03-01")
    next_day_index = "my-index-2016.03.01"

    expect_search(
      indices: [@current_index, next_day_index],
      payload: subsequent_search(search_after: [1]),
      result: {:hits, new_documents}
    )

    current_position = %{current_index: @current_index, sort: [1]}
    result = Searcher.get_new_messages(next_day, current_position)

    assert result.position == %{current_index: next_day_index, sort: [3]}
    assert result.hits == new_documents
  end

  defp expect_search(options) do
    search = keywords_to_map(options)
    payload = search.payload
    indices = Map.get(search, :indices, [@current_index])
    MockClient |> expect(:search, fn _url, ^indices, ^payload -> search.result end)
  end

  defp initial_search do
    %{
      size: 1,
      sort: [%{"@timestamp" => "desc"}]
    }
  end

  defp subsequent_search(extra_fields \\ []) do
    payload = %{
      size: 1000,
      sort: ["@timestamp"],
      query: %{
        query_string: %{
          query: "bad hombre"
        }
      }
    }

    keywords_to_map(extra_fields) |> Map.merge(payload)
  end

  defp document_with_sort(sort) do
    %{
      "sort" => sort,
      "_source" => %{
        "message" => "Document content"
      }
    }
  end

  defp keywords_to_map(keywords) do
    Enum.into(keywords, %{})
  end
end
