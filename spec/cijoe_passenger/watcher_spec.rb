require 'spec_helper'

describe Watcher do
  it "does a select across all entries in root" do
    dirs = ['dir']
    File.stub!(:directory?).with('dir').and_return(true)
    Dir.should_receive(:[]).with('*').and_return(dirs)
    Watcher.dirs.should == dirs
  end

  it "selects only directories in root" do
    dirs = ['dir', 'file']
    File.should_receive(:directory?).with('dir').and_return(true)
    File.should_receive(:directory?).with('file').and_return(false)
    Dir.stub!(:[]).and_return(dirs)
    Watcher.dirs.should == ['dir']
  end
end