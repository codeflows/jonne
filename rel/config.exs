use Mix.Releases.Config,
  default_release: :default,
  default_environment: Mix.env()

environment :default do
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
