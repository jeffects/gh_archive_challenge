# GitHub Archive Leaderboard challenge

## Overview

This challenge has been very fun.  When I first glanced at this problem I thought
of using Google BigQuery to handle querying of the activities and to limit the
amount of requests.  However, in order to use BigQuery, we must input valid
credentials in order to use their API.  Also, the requirements did not specify
to allow Google API credentials to be passed in as options.  That led me to
assume that we either go with fetching of the archived json provided by
Githubarchive.org or store my credentials in the application, which is bad
practice.  Thus I decided to get the dataset via GitHub Archive HTTP service.

I have been meaning to test out Google's BigQuery.  Seeing how it queries GBs of
data in seconds is amazing.  How I normally will approach this is with TDD but
is not required.

## Requirements:
```
gem install yajl-ruby
gem install bigquery
```

## Repo
```
https://github.com/jeffects/gh_archive_challenge
```

## Going further response

* There are [18 published Event Types](http://developer.github.com/v3/activity/events/types/). How would you manage them? What would you do if GitHub added more Event Types?
```
I will not manage Event Types because this application currently does not store
event types.  Storing of the event types will possibly require updates to this 
application as GitHub or GitHub Archive updates.  Although GitHub API is versioned,
Githubarchive.org's HTTP service is not.
```
* What factors impact performance? What would you do to improve them?
```
Githubarchive.org provides activities that is aggregated in hourly archives.
This impacts performance because in order to get those archives, multiple
requests and responses must be made and handled.

What I did to improve the performance is use Google BigQuery to query the
the data that is publicly available.  This greatly improves the performance:

Command Executed: 
	gh_repo_stats --after 2012-11-01T13:00:00Z --before 2012-11-02T03:12:14-03:00 --event PushEvent -n 10
Without BigQuery:
	6.85s user 0.66s system 37% cpu 19.909 total
BigQuery Time:
	0.89s user 0.23s system 25% cpu 4.382 total
```

* The example shows one type of output report. How would you add additional reporting formats?
```
I would add a command line option where it will be used by the leaderboard class
to display or output the repo stats in different format.
```

* If you had to implement this using only one gem, which would it be? Why?
```
I will use yajl-ruby (https://github.com/brianmario/yajl-ruby) because it makes
JSON parsing easy efficiently.

The BigQuery gem will improve performance but
but requires user to use their own credentials, which is also outside of the scope
of this application.

I also like the debugger gem for bug fixes.
```

## Further Improvements
* Better handling of possible edge cases
  * Did not ensure every edge case is handled properly
  * Better exit code.  I believe typically if invalid arguments are passed in, the exit code is 2
* Some methods are too long
  * One of Sandi Metz's rule for developers is to have 5 lines per method.  Upon examining my code, you will see I am not meeting this.
* Gemfile will be nice.
  * Multiple dependencies, not obvious for the user :/
* Documentation

## References

```
http://ruby-doc.org/stdlib-2.1.2/libdoc/optparse/rdoc/OptionParser.html
https://github.com/brianmario/yajl-ruby
http://www.githubarchive.org/
```
