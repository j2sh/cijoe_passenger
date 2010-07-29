module CIJoePassenger
  class Watcher
    attr_reader :name

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

    def initialize(name)
      @name = name
    end

    def current_head
      @current_head ||= Git.ls_remote_origin_master.split(' ').first
    end

    def prev_head_path
      "tmp/#{name}"
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
      uri = URI.parse("#{Config.cijoe_url}/#{name}")
      Net::HTTP.post_form(url, {})
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