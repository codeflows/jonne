defmodule Jonne.Searcher do
  require Logger

  @elasticsearch_client Application.get_env(:jonne, :elasticsearch_client)
  @url Application.fetch_env!(:jonne, :elasticsearch_url)
  @index_prefix Application.fetch_env!(:jonne, :elasticsearch_index_prefix)
  @query Application.fetch_env!(:jonne, :elasticsearch_query)
  @sort_column Application.get_env(:jonne, :elasticsearch_sort_column, "@timestamp")

  def get_initial_position(current_time) do
    current_index = index_name(current_time)

    Logger.debug(
      "Retrieving latest document from #{current_index} to determine initial sort position"
    )

    search = %{
      size: 1,
      sort: [%{@sort_column => "desc"}]
    }

    result = @elasticsearch_client.search(@url, [current_index], search)

    initial_sort =
      case result do
        {:hits, [single_hit]} -> single_hit["sort"]
        {:hits, []} -> nil
      end

    if initial_sort do
      Logger.debug("Initial position is #{inspect(initial_sort, charlists: :as_lists)}")
    else
      Logger.debug(
        "No documents found from #{current_index}. It may not have been created yet or the configuration might be incorrect."
      )
    end

    %{
      current_index: current_index,
      sort: initial_sort
    }
  end

  def get_new_messages(current_time, position) do
    search_template = %{
      # If there are more than 1000 matches within poll_interval, messages will be dropped
      size: 1000,
      sort: [@sort_column],
      query: %{
        query_string: %{
          query: @query
        }
      }
    }

    search =
      if position.sort do
        Map.put(search_template, :search_after, position.sort)
      else
        search_template
      end

    new_index = index_name(current_time)

    indices =
      if new_index == position.current_index do
        [position.current_index]
      else
        [position.current_index, new_index]
      end

    Logger.debug(
      "Get new messages from #{Enum.join(indices, ", ")}, searching after sort position #{
        inspect(position.sort)
      }"
    )

    {:hits, hits} = @elasticsearch_client.search(@url, indices, search)

    new_position =
      if length(hits) > 0 do
        newest_hit = List.last(hits)

        %{
          current_index: new_index,
          sort: newest_hit["sort"]
        }
      else
        %{
          current_index: new_index,
          sort: position.sort
        }
      end

    %{
      position: new_position,
      hits: hits
    }
  end

  defp index_name(current_time) do
    date = current_time |> Timex.format!("{YYYY}.{0M}.{0D}")
    @index_prefix <> date
  end
end
