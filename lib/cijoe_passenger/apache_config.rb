module CIJoePassenger
  class ApacheConfig < Thor
    include Thor::Actions

    namespace :apache_config

    desc "add_rack_base_uri NAME", "adds app with NAME to apache config"
    def add_rack_base_uri(name)
      inject_into_file(Config.apache_config_path,
        "  RackBaseURI /#{name}/public\n",
        :after => "<VirtualHost *:80>\n")
    end
  end
end