module GHRepoStats

  class LeaderBoard
    def initialize(events)
      @events = events
      @leader_board = Hash.new
    end

    def display_stats
      @events.each do |repo, num_events|
        puts repo + ' - ' + num_events.to_s + ' events'
      end
    end
  end

end
