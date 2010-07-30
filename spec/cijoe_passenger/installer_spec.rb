require 'spec_helper'

describe Installer do
  before do
    @installer = Installer.new(['name', 'repo'])
  end

  it "installs the bundle for the project" do
    Sh.should_receive(:exec).with("[[ -f Gemfile ]] && bundle install", 'name')
    @installer.bundle_install
  end

  it "links to the template rack config" do
    Sh.should_receive(:exec).with("ln -s config/config.ru name/public/config.ru")
    @installer.link_rack_config
  end
  
  it "configures cijoe runner in git config" do
    CIJoePassenger::Config.stub!(:runner).and_return('runner')
    Git.should_receive(:add_config_to_repo).with("cijoe.runner", "runner", 'name')
    @installer.configure_cijoe_runner
  end
  
  it "adds the app to the apache config" do
    ApacheConfig.should_receive(:add_app).with('name')
    @installer.add_app_to_apache_config
  end

  it "clones the repo" do
    Git.should_receive(:clone).with('repo')
    @installer.clone
  end

  it "reminds peeps to setup database.yml" do
    @installer.should_receive(:puts).with("Don't forget to setup a config/database.yml")
    @installer.remind
  end
end
