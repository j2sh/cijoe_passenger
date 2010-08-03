module CIJoePassenger
  class Install < Thor::Group
    include Thor::Actions

    namespace :install
    argument :cijoe_url, :type => :string, :desc => "The URL of the CIJoe server"
    source_root File.join(File.dirname(__FILE__), '..', '..')

    def install
      @cijoe_url = cijoe_url
      @app_path = Dir.pwd
      directory 'templates', @app_path
    end
  end
end