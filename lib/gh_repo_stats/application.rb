module GHRepoStats

  class Application
    def initialize
      @options = parse_options
    end

    def run
      events = StatsQuery.new(@options).fetch_events # sync process, possible bottleneck
      @leader_board = LeaderBoard.new(events)
      @leader_board.display_stats
    end

    def parse_options
      options = {}
      parser = OptionParser.new do |opts|
        opts.banner = "Usage: gh_repo_stats [--after DATETIME] [--before DATETIME] 
          [--event EVENT_NAME] [-n COUNT]"
        opts.on("--after DATETIME", Time) { |datetime| options[:after] = datetime }
        opts.on("--before DATETIME", Time) { |datetime| options[:before] = datetime }
        opts.on("--event EVENT_NAME") { |event_name| options[:event_name] = event_name }
        opts.on("-n COUNT", Integer) { |count| options[:count] = count }
        # optimization
        opts.on("--client_id CLIENT_ID") { |client_id| options[:client_id] = client_id }
        opts.on("--service_email SERVICE_EMAIL") { |service_email| options[:service_email] = service_email }
        opts.on("--key_path KEY_PATH") { |key_path| options[:key_path] = key_path }
        opts.on("--project_id PROJECT_ID") { |project_id| options[:project_id] = project_id }
      end

      begin
        parser.parse!
      rescue OptionParser::InvalidOption, OptionParser::MissingArgument,
        OptionParser::InvalidArgument => err

        abort "gh_repo_stats: #{err.message}\nusage: gh_repo_stats [--after DATETIME] [--before DATETIME] [--event EVENT_NAME] [-n COUNT]"
      end

      options
    end
  end

end
