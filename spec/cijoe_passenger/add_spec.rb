require 'spec_helper'

describe Add do
  before do
    @git = stub
    Git.stub!(:new).with(['name']).and_return(@git)
    @add = Add.new(['name', 'repo'])
  end

  it "has a git instance by default" do
    @add.git.should == @git
  end

  it "clones the repo" do
    @git.should_receive(:clone).with(['repo'])
    @add.clone
  end

  it "links to the template rack config" do
    @add.should_receive(:run).with("ln -s ../config/config.ru name/config.ru")
    @add.link_rack_config
  end
  
  it "adds the app to the apache config" do
    CIJoePassenger::Config.stub!(:apache_config_path).and_return('apache_config_path')
    @add.should_receive(:inject_into_file).with('apache_config_path', "  RackBaseURI /name/public\n", :after => "<VirtualHost *:80>\n")
    @add.add_app_to_apache_config
  end
  
  it "configures cijoe runner in git config" do
    CIJoePassenger::Config.stub!(:runner).and_return('runner')
    @git.should_receive(:add_config_to_repo).with(["cijoe.runner", 'runner'])
    @add.configure_cijoe_runner
  end

  it "create empty directory skeleton" do
    @add.should_receive(:empty_directory).with('name/public')
    @add.create_empty_public
  end

  it "reminds peeps to setup database.yml" do
    @add.should_receive(:puts).with("Don't forget to setup database.yml")
    @add.remind
  end
end
