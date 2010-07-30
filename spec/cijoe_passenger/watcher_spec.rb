require 'spec_helper'

describe Watcher, "the class" do
  describe "with repos" do
    it "calls scan on each new watcher" do
      @repo.should_receive(:scan)
      Watcher.stub(:new).and_return(@repo)
      Watcher.scan
    end
  end

  describe Watcher, "the instance" do
    before do
      @watcher = Watcher.new('name')
    end

    it "refreshes by updating prev head and requesting a build" do
      @watcher.should_receive(:update_prev_head)
      @watcher.should_receive(:request_build)
      @watcher.refresh
    end

    it "refreshes if refreshable during scan" do
      @watcher.stub!(:refreshable?).and_return(true)
      @watcher.should_receive(:refresh)
      @watcher.scan
    end

    it "does not refresh if not refreshable during scan" do
      @watcher.stub!(:refreshable?).and_return(false)
      @watcher.should_receive(:refresh).never
      @watcher.scan
    end
  end
end