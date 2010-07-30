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
end