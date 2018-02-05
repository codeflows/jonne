use Mix.Releases.Config,
  default_release: :jonne,
  default_environment: Mix.env()

environment :dev do
  set dev_mode: true
  set include_erts: true
  set cookie: :"bad hombre"
end

environment :prod do
  set dev_mode: false
  set include_erts: false
  set include_src: false
  set cookie: :"bad hombre"
end

release :jonne do
  set version: current_version(:jonne)
  set applications: [
    :runtime_tools
  ]
end
