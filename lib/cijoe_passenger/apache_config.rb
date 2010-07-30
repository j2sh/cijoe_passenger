module CIJoePassenger
  module ApacheConfig
    def self.template
      wd = File.expand(Dir.pwd)
      <<-TEMPLATE
      <VirtualHost *:80>

        ServerName #{Config.cijoe_url}
        SetEnv PATH /usr/bin:/usr/local/bin
        SetEnv RAILS_RELATIVE_URL_ROOT
        DocumentRoot #{wd}

        ErrorLog #{wd}/logs/ci-error_log
        CustomLog #{wd}/logs/ci-access_log combined

        PassengerMaxInstancesPerApp 1
        # set this higher than the total number of cijoe apps you have
        PassengerMaxPoolSize 20
      </VirtualHost>
      TEMPLATE
    end

    def self.read
      File.open(Config.apache_config_path, "r") do |f|
        f.readlines
      end
    end

    def add_app(name)
      config = read.insert(1, "\tRackBaseURI /#{name}/public\n")
      write(config)
    end

    def write(config)
      File.open(Config.apache_config_path, 'w') do |f|
        f.writes(config.join(""))
      end
    end
  end
end