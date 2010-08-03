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
    @git.should_receive(:clone).with('repo')
    @add.clone
  end
  
  it "configures cijoe runner in git config" do
    CIJoePassenger::Config.stub!(:runner).and_return('runner')
    @git.should_receive(:add_config_to_repo).with("cijoe.runner", 'runner')
    @add.configure_cijoe_runner
  end

  it "reminds peeps to setup database.yml" do
    @add.should_receive(:puts).with("Don't forget to setup database.yml")
    @add.remind
  end
end
