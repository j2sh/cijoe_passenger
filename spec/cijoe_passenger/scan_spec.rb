require 'spec_helper'

describe Scan, "the instance" do
  before do
    @scan = Scan.new
  end

  it "invoke refresh on each refreshable project" do
    project = mock
    project.should_receive(:build)
    Project.stub!(:stale).and_return([project])
    @scan.scan
  end
end
