require 'spec_helper'

describe Git do
  it "clones a repo" do
    Sh.should_receive(:exec).with("git clone repo")
    Git.clone('repo')    
  end

  it "lists the remote origin master" do
    Sh.should_receive(:exec).with("git ls-remote origin master")
    Git.ls_remote_origin_master
  end

  it "lists the remote origin master" do
    Sh.should_receive(:exec).with("git config --add \"key\" \"value\"", 'repo')
    Git.add_config_to_repo('key', 'value', 'repo')
  end

  it "generates a path to git based on dir" do
    File.stub!(:join).with('dir', '.git').and_return('dir/.git')
    Git.git_path('dir').should == 'dir/.git'
  end

  it "checks to see if git_path exists in order to determine if repo exists" do
    Git.stub!(:git_path).with('dir').and_return('dir/.git')
    File.should_receive(:exist?).with('dir/.git').and_return(true)
    Git.repo?('dir').should == true
  end
end