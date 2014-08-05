module GHRepoStats

  class StatsQuery
    def initialize(options)
      @after = options[:after].utc
      @before = options[:before].utc
      @event_name = options[:event_name]
      @count = options[:count] || 10
      @date_ranges = build_date_and_hours

      # BigQuery
      @client_id = options[:client_id]
      @service_email = options[:service_email]
      @key_path = options[:key_path]
      @project_id = options[:project_id]
    end

    def fetch_events
      unless @client_id.nil? || @service_email.nil? || @key_path.nil? || @project_id.nil?
        get_events_from_big_query
      else
        get_events_from_gh_archive
      end
    end

  private
    # HACK: method might be too long
    def get_events_from_gh_archive
      repo_events = Hash.new(0)
      @date_ranges.each do |date_range|
        url = "http://data.githubarchive.org/#{date_range}.json.gz"
        begin
          gz = open(URI.parse(url))
        rescue OpenURI::HTTPError
          next # or raise error
        end
        js = Zlib::GzipReader.new(gz).read
        Yajl::Parser.parse(js) do |event|
          # filter out messages depending on event
          if event['type'] =~ /#{@event_name}/
            owner_and_repo = owner_and_repo_name_from_url(event['repository']['url'])
            repo_events[owner_and_repo] += 1
          end
        end
      end
      # sort
      repo_events.sort_by {|repo, repo_event| repo_event }.reverse.slice(0..@count-1)
    end

    # BIG QUERY
    # HACK: A lot of magic numbers
    def get_events_from_big_query
      result = query_data
      repo_events = Hash.new(0)
      rows = result['rows']
      rows.each do |row|
        owner_and_repo = owner_and_repo_name_from_url(row['f'][-1]['v'])
        repo_events[owner_and_repo] = row['f'][1]['v']
      end
      repo_events
    end

    def owner_and_repo_name_from_url(url)
      url.split('/')[-2..-1].join('/')
    end

    def query_data
      opts = {}
      opts['client_id']     = @client_id
      opts['service_email'] = @service_email
      opts['key']           = @key_path
      opts['project_id']    = @project_id

      bq = BigQuery.new(opts)
      result_hash = bq.query(
        "SELECT repository_name, count(repository_name) as pushes, repository_description, repository_url
        FROM [githubarchive:github.timeline]
        WHERE type='#{@event_name}'
          AND PARSE_UTC_USEC(created_at) >= PARSE_UTC_USEC('#{@after.strftime("%Y-%m-%d %H:%M:%S")}') 
          AND PARSE_UTC_USEC(created_at) < PARSE_UTC_USEC('#{@before.strftime("%Y-%m-%d %H:%M:%S")}')
        GROUP BY repository_name, repository_description, repository_url
        ORDER BY pushes DESC
        LIMIT #{@count}"
      )
      result_hash
    end

    def build_date_and_hours
      date_and_hours = []
      one_hour = 3600
      time_pointer = @after

      while time_pointer < @before
        date_and_hours << time_pointer.strftime("%Y-%m-%d-%H")
        time_pointer += one_hour
      end
      date_and_hours
    end

  end
end

class Time
  def seconds_until_midnight
    end_of_day.to_i - to_i
  end

  def end_of_day
    Time.utc(year, month, day, 23, 59, 59)
  end
end
