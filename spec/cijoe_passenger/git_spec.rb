require 'spec_helper'

describe Git do
  before do
    @git = Git.new(['name'])
  end

  it "has a path to the repo" do
    @git.repo_path.should == "name/work"
  end

  it "has a path to the git config dir" do
    @git.git_path.should == "name/work/.git"
  end

  it "checks to see if git_path exists in order to determine if repo exists" do
    @git.stub!(:git_path).and_return('git_path')
    File.should_receive(:exist?).with('git_path').and_return(true)
    @git.repo?.should == true
  end

  it "runs a block inside the repo directory" do
    @git.stub!(:repo_path).and_return('repo_path')
    @git.should_receive(:inside).with('repo_path')
    @git.inside_repo
  end

  it "runs git ls-remote origin master in the repo dir and returns output" do
    @git.stub!(:inside_repo).and_yield
    @git.should_receive(:run).with("git ls-remote origin master").and_return('ls_remote_origin_master')
    @git.ls_remote_origin_master.should == 'ls_remote_origin_master'
  end

  it "split on space and pull the first segment back from ls_remote_origin_master as origin_head_sha" do
    @git.stub!(:ls_remote_origin_master).and_return("123 some/junk")
    @git.upstream_head.should == '123'
  end

  it "clones a repo into the repo_path" do
    @git.stub!(:repo_path).and_return('repo_path')
    @git.should_receive(:run).with("git clone repo repo_path")
    @git.clone('repo')
  end

  it "runs git ls-remote origin master in the repo dir and returns output" do
    @git.stub!(:inside_repo).and_yield
    @git.should_receive(:run).with("git config --add \"key\" \"value\"")
    @git.add_config_to_repo('key', 'value')
  end
end