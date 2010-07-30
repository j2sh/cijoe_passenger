module CIJoePassenger
  class Refresher < Thor::Group
    namespace :refresh
    argument :name, :type => :string, :desc => "The project name"

    def update_prev_head
      Project.new(name).update_prev_head
    end

    def request_build
      uri = URI.parse("http://#{Config.cijoe_url}/#{name}")
      Net::HTTP.post_form(url, {})
    end
  end
end