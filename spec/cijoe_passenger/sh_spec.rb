require 'spec_helper'

describe Sh do
  it "executes a command" do
    Sh.should_receive(:`).with("echo")
    Sh.exec("echo")
  end

  it "have a default dir of ." do
    Dir.should_receive(:chdir).with('.')
    Sh.exec("echo")
  end

  it "have a custom dir" do
    Dir.should_receive(:chdir).with('dir')
    Sh.exec("echo", 'dir')
  end
end