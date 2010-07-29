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

  it "check to see if git_path exists in order to determine if repo exists" do
    Watcher.stub!(:git_path).with('dir').and_return('dir/.git')
    File.should_receive(:exist?).with('dir/.git').and_return(true)
    Watcher.repo?('dir').should == true
  end
end