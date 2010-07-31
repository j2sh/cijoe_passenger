require 'spec_helper'

describe Add do
  before do
    @add = Add.new(['name', 'repo'])
  end

  it "installs the bundle for the project" do
    Sh.should_receive(:exec).with("[[ -f Gemfile ]] && bundle install", 'name')
    @add.bundle_install
  end

  it "links to the template rack config" do
    Sh.should_receive(:exec).with("ln -s config/config.ru name/public/config.ru")
    @add.link_rack_config
  end
  
  it "configures cijoe runner in git config" do
    CIJoePassenger::Config.stub!(:runner).and_return('runner')
    Git.should_receive(:add_config_to_repo).with("cijoe.runner", "runner", 'name')
    @add.configure_cijoe_runner
  end
  
  it "adds the app to the apache config" do
    ApacheConfig.should_receive(:add_app).with('name')
    @add.add_app_to_apache_config
  end

  it "clones the repo" do
    Git.should_receive(:clone).with('repo')
    @add.clone
  end

  it "reminds peeps to setup database.yml" do
    @add.should_receive(:puts).with("Don't forget to setup a config/database.yml")
    @add.remind
  end
end
