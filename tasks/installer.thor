class Installer < Thor

  desc "add APP_NAME REPO", "setup a cijoe instance for a repo"
  method_options :campfire => :hash
  def add(name, repo)

    Installer.clone_repo(repo, name)
    Installer.bundle_install(name)
    Installer.link_config_rackup(name)
    Installer.update_apache_config(name)
    Installer.configure_cijoe_runner(name)

    # configure_campfire
    # 
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

    puts "Don't forget to setup a config/database.yml"
  end
end
