module CIJoePassenger
  class Add < Thor::Group
    include Thor::Actions
    attr_reader :git
    namespace :add
    argument :name, :type => :string, :desc => "The project name"
    argument :repo, :type => :string, :desc => "The git repo address"
    argument :campfire, :type => :hash, :desc => "A hash of campfire options", :default => {}

    def initialize(args=[], options={}, config={})
      super
      @git = Git.new([name])
    end

    def clone
      git.clone(repo)
    end

    def link_rack_config
      from = File.join("..", "config", "config.ru")
      to = File.join(name, "config.ru")
      run "ln -s #{from} #{to}"
    end
    
    def add_app_to_apache_config
      inject_into_file(Config.apache_config_path,
        "  RackBaseURI /#{name}/public\n",
        :after => "<VirtualHost *:80>\n")
    end
    
    def configure_cijoe_runner
      git.add_config_to_repo("cijoe.runner", Config.runner)
    end

    def configure_campfire
      campfire.each do |k, v|
        @git.add_config_to_repo("campfire.#{k}", v)
      end
    end

    def create_empty_public
      empty_directory File.join(name, 'public')
    end

    def remind
      puts "Don't forget to setup database.yml"
    end
  end
end