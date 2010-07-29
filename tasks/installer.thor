class Installer < Thor

  desc "add APP_NAME REPO", "setup a cijoe instance for a repo"
  method_options :campfire => :hash
  def add(name, repo)

    clone_repo(repo, name)
    bundle_install(name)
    link_config_rackup(name)
    update_apache_config(name)
    configure_cijoe_runner(name)

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
