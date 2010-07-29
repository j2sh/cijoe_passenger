module CIJoePassenger
  class Watcher
    attr_reader :repo

    class << self
      def dirs
        Dir['*'].select{|f| File.directory?(f)}
      end

      def git_path(dir)
        File.join(dir, '.git')
      end

      def repo?(dir)
        File.exist?(git_path(dir))
      end

      def repos
        dirs.select{|d| repo?(d) }
      end

      def scan
        repos.each do |r|
          Watcher.new(r).scan
        end
      end
    end

    def initialize(repo)
      @repo = repo
    end

    def sh(command, dir = repo)
      Dir.chdir(dir) { `#{command}` }
    end

    def ls_remote_origin_master
      sh "git ls-remote origin master"
    end

    def current_head
      @current_head ||= ls_remote_origin_master.split(' ').first
    end

    def prev_head_path
      "tmp/#{repo}"
    end

    def prev_head_file?
      File.exist?(prev_head_path)
    end

    def prev_head
      File.open(prev_head_path) do |f|
        f.readline.chop
      end if prev_head_file?
    end

    def refreshable?
      current_head != prev_head
    end

    def update_prev_head
      File.open(prev_head_path, "w") do |f|
        f << current_head
      end
    end

    def request_build
    end

    def refresh
      update_prev_head
      request_build
    end

    def scan
      refresh if refreshable?
    end
  end
end