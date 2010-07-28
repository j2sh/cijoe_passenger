class Installer < Thor

  desc "install APP_NAME REPO", "setup a cijoe instance for a repo"
  method_options :campfire => :hash
  def run(name, repo)
    working_directory = "/var/www/cijoe-passenger"

    `git clone #{repo} #{File.join(working_directory, "name")}`
    `cd #{working_directory}; [[ -f Gemfile ]] && bundle install`
    `ln -s #{File.join(working_directory, "config", "config.ru"} #{File.join(working_directory, "name", "public", "config.ru")}`

    File.open()

    {
      "user"=>options[:campfire][:user],
      "pass"=>options[:campfire][:pass],
      "subdomain"=>options[:campfire][:subdomain],
      "room"=>options[:campfire][:room],
      "ssl"=>true
    }.each do |k,v|
      `git config --add campfire.#{k} #{v}`
    end

    puts "Don't forget to setup a config/database.yml"
  end
end
