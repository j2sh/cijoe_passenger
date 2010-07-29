require 'spec_helper'

describe Installer, "the class" do
  it "should clone the repository into the cijoe-passenger directory" do
    Installer.should_receive(:system).with("git clone repository.git /var/www/cijoe-passenger/bypass")
    Installer.clone_repo("repository.git", "bypass")
  end

  it "should run bundle install if a Gemfile exists" do
    Installer.should_receive(:system).with("cd /var/www/cijoe-passenger/bypass; [[ -f Gemfile ]] && bundle install")
    Installer.bundle_install("bypass")
  end

  it "should link the config rackup file" do
    Installer.should_receive(:system).with("ln -s /var/www/cijoe-passenger/config/config.ru /var/www/cijoe-passenger/bypass/public/config.ru")
    Installer.link_config_rackup("bypass")
  end

  it "should add a new line to the apache config" do
    cijoe_config_filename = "/etc/httpd/conf.d/cijoe.conf"

    File.stub!(:new).with(cijoe_config_filename, "r").and_return(stub(:readlines => ["Line 1\n", "Line 2\n", "Last Line"]))

    write_file = mock
    write_file.should_receive(:writes).with("Line 1\n\tRackBaseURI /bypass/public\nLine 3\nLast Line")
    File.stub!(:new).with(cijoe_config_filename, "w").and_return(write_file)

    Installer.update_apache_config("bypass")
  end

  it "should add a git config as cijoe.runner for 'rake cruise'" do
    Installer.should_receive(:system).with("cd /var/www/cijoe-passenger/bypass; git config --add cijoe.runner \"rake cruise\"")
    Installer.configure_cijoe_runner("bypass")
  end
end
