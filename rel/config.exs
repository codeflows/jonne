use Mix.Releases.Config,
  default_release: :default,
  default_environment: Mix.env()

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"|JDRG&s%8XCRS%L~%C~*XcuAT~6R9i/JeviJ}mS53Gu)XjR=&(8,9iI6$Q];:,c&"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"3}AujsnJh}bkQ0weXq?GECpd)Rl5G@uO(:_AJ[]K,IKeCL,}9%)<RrX8=w,</(8]"
end

release :jonne do
  set version: current_version(:jonne)
  set applications: [
    :runtime_tools
  ]
end
