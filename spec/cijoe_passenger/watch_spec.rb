require 'spec_helper'

describe Watch, "the instance" do
  before do
    @watch = Watch.new
  end

  it "invoke refresh on each refreshable project" do
    project = stub
    project.stub(:name).and_return('project')
    Project.stub!(:refreshable).and_return([project])
    @watch.should_receive(:invoke).with("refresh", ['project'])
    @watch.scan
  end
end
