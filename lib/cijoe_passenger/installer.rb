module CIJoePassenger
  module Installer
    extend self

    WORKING_DIRECTORY = "/var/www/cijoe-passenger/"

    def clone_repo(repo, name)
      system "git clone #{repo} #{File.join(WORKING_DIRECTORY, name)}"
    end

    def bundle_install(name)
      system "cd #{File.join(WORKING_DIRECTORY, name)}; [[ -f Gemfile ]] && bundle install"
    end

    def link_config_rackup(name)
      from = File.join(WORKING_DIRECTORY, "config", "config.ru")
      to = File.join(WORKING_DIRECTORY, "bypass", "public", "config.ru")

      system "ln -s #{from} #{to}"
    end

    def update_apache_config(name)
      cijoe_config_filename = "/etc/httpd/conf.d/cijoe.conf"

      apache_config = File.new(cijoe_config_filename, "r").readlines
      apache_config.insert(1, "\tRackBaseURI /#{name}/public\n")

      current_count = apache_config[-2].chomp.split(' ').last.to_i
      apache_config[-2].gsub!("#{current_count}", "#{current_count+1}")

      File.new(cijoe_config_filename, "w").writes(apache_config.join(""))
    end

    def configure_cijoe_runner(name)
      system "cd #{File.join(WORKING_DIRECTORY, name)}; git config --add cijoe.runner \"rake cruise\""
    end

    def configure_campfire
    end
  end
end
