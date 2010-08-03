module CIJoePassenger
  class Add < Thor::Group
    include Thor::Actions
    attr_reader :git
    namespace :add
    argument :name, :type => :string, :desc => "The project name or repo if no name given"
    argument :repo, :type => :string, :desc => "The git repo address if name differs from repo name", :default => ''
    argument :campfire, :type => :hash, :desc => "A hash of campfire options", :default => {}

    def initialize(args=[], options={}, config={})
      super
      if @repo == ''
        @repo = @name
        @name = @repo.slice(/\/(.*).git$/, 1)
      end
      @git = Git.new([name])
    end

    def clone
      git.clone(repo)
    end

    def add_app_to_rack
      append_file 'config.ru' do
        <<-CONFIG
        map "/#{name}" do
          work_path = File.join(Dir.pwd, '#{name}')
          module CIJoePassenger
            module Apps
              class #{name.capitalize} < CIJoe::Server; end
            end
          end
          CIJoePassenger::Apps::#{name.capitalize}.configure do |config|
            config.set :project_path, work_path
            config.set :show_exceptions, true
            config.set :lock, true
          end
          run CIJoePassenger::Apps::#{name.capitalize}
        end
        CONFIG
      end
    end

    def configure_cijoe_runner
      git.add_config_to_repo("cijoe.runner", Config.runner)
    end

    def configure_campfire
      campfire.each do |k, v|
        @git.add_config_to_repo("campfire.#{k}", v)
      end
    end

    def restart
      run "touch tmp/restart.txt"
    end

    def remind
      puts "Don't forget to setup database.yml"
    end
  end
end