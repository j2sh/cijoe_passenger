module CIJoePassenger
  class Watcher
    attr_reader :repo

    def self.dirs
      Dir['*'].select{|f| File.directory?(f)}
    end

    def self.repos
      dirs.select{|d| repo?(d) }
    end

    def self.repo?(dir)
      File.exist?(File.join(dir, '.git'))
    end

    def self.scan
      repos.each do |r|
        watcher = Watcher.new(r)
        watcher.scan
      end
    end

    def initialize(repo)
      @repo = repo
    end

    def scan
      puts head
    end

    def head
      Dir.chdir(repo) do
        `git ls-remote origin master`.split(' ').first
      end
    end
  end
end