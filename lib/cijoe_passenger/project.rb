module CIJoePassenger
  class Project
    attr_reader :name, :git

    def self.dirs
      Dir['*'].select do |name|
        Git.new(name).repo?
      end
    end

    def self.all
      dirs.collect{|name| Project.new(name) }
    end

    def self.stale
      all.select(&:stale?)
    end

    def initialize(name)
      @name = name
      @git = Git.new([name])
    end

    def stale?
      git.current_head != git.upstream_head
    end

    def build
      uri = URI.parse("http://#{Config.cijoe_url}/#{name}")
      Net::HTTP.post_form(uri, {})
    end
  end
end