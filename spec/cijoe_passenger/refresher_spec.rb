require 'spec_helper'

describe Refresher do
  before do
    @refresher = Refresher.new(['name'])
  end

  it "proxy update_prev_head to the project" do
    project = mock
    project.should_receive(:update_prev_head)
    Project.should_receive(:new).with('name').and_return(project)
    @refresher.update_prev_head
  end

  it "proxy update_prev_head to the project" do
    CIJoePassenger::Config.stub!(:cijoe_url).and_return('cijoe_url')
    URI.should_receive(:parse).with("http://cijoe_url/name").and_return('uri')
    Net::HTTP.should_receive(:post_form).with('uri', {})
    @refresher.request_build
  end
end