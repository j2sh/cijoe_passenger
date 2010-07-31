require 'spec_helper'

describe Watcher, "the instance" do
  before do
    @watcher = Watcher.new
  end

  it "invoke refresh on each refreshable project" do
    project = stub
    project.stub(:name).and_return('project')
    Project.stub!(:refreshable).and_return([project])
    @watcher.should_receive(:invoke).with("refresh", ['project'])
    @watcher.scan
  end
end
