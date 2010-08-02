module CIJoePassenger
  class Install < Thor::Group
    include Thor::Actions

    namespace :install
    source_root File.join(File.dirname(__FILE__), '..', '..')

    def install
      @cijoe_url = Config.cijoe_url
      @app_path = Dir.pwd
      directory 'templates', Dir.pwd
    end
  end
end