module CIJoePassenger
  class Installer
    attr_reader :name, :repo

    def initialize(name, repo)
      @name = name
      @repo = repo
    end

    def bundle_install
      Sh.exec "[[ -f Gemfile ]] && bundle install", name
    end

    def link_rack_config
      from = File.join("config", "config.ru")
      to = File.join(name, "public", "config.ru")
      Sh.exec "ln -s #{from} #{to}"
    end

    def apache_config
      @apache_config ||= File.open(Config.apache_config_path, "r") do |f|
        f.readlines
      end
    end

    def add_rack_base_uri_to_apache_config
      apache_config.insert(1, "\tRackBaseURI /#{name}/public\n")
    end

    def save_apache_config
      File.open(Config.apache_config_path, 'w') do |f|
        f.writes(apache_config.join(""))
      end
    end

    def update_apache_config
      add_rack_base_uri_to_apache_config
      save_apache_config
    end

    def configure_cijoe_runner
      Git.add_config_to_repo("cijoe.runner", "rake cruise", name)
    end

    def configure_campfire
      # if options[:campfire] && options[:campfire].keys == [:user, :pass, :subdomain, :room]
      #   { "user"=>options[:campfire][:user],
      #     "pass"=>options[:campfire][:pass],
      #     "subdomain"=>options[:campfire][:subdomain],
      #     "room"=>options[:campfire][:room],
      #     "ssl"=>true }.each do |k,v|
      # 
      #     `git config --add campfire.#{k} #{v}`
      #   end
      # end
    end

    def add
      Git.clone(repo)
      bundle_install
      link_rack_config
      update_apache_config
      configure_cijoe_runner
      configure_campfire
      puts "Don't forget to setup a config/database.yml"
    end
  end
end
