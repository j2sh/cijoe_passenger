module CIJoePassenger
  class Watcher
    attr_reader :repo

    def self.dirs
      Dir['*'].select{|f| File.directory?(f)}
    end

    def self.git_path(dir)
      File.join(dir, '.git')
    end

    def self.repo?(dir)
      File.exist?(git_path(dir))
    end

    def self.repos
      dirs.select{|d| repo?(d) }
    end

    def self.scan
      repos.each do |r|
        Watcher.new(r).scan
      end
    end

    def initialize(repo)
      @repo = repo
    end

    def sh(command)
      Dir.chdir(repo) { `#{command}` }
    end

    def ls_remote_origin_master
      sh "git ls-remote origin master"
    end

    def origin_master_head
      ls_remote_origin_master.split(' ').first
    end

    def scan
      puts origin_master_head
    end
  end
end