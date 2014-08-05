# GitHub Archive leaderboard challenge
[GitHub Archive](http://www.githubarchive.org) provides stats for
projects on GitHub via a RESTful HTTP service. 


Create a command-line program that lists the most active repositories
for a given time range. It should support the following interface:

```
  gh_repo_stats [--after DATETIME] [--before DATETIME] [--event EVENT_NAME] [-n COUNT]
```


```
gh_repo_stats --after 2012-11-01T13:00:00Z --before 2012-11-02T03:12:14-03:00 --event PushEvent --count 42

sakai-mirror/melete - 168 events
runningforworldpeace/feeds - 103 events
chapuni/llvm-project-submodule - 98 events
chapuni/llvm-project - 98 events
Frameset91/untitled0815 - 94 events
josmera01/juanrueda-internation - 78 events
artmig/artmig.github.com - 76 events
mozilla/mozilla-central - 69 events
bcomdlc/bcom-homepage-archive - 68 events
sakai-mirror/ambrosia - 68 events
sakai-mirror/test-center - 65 events
sakai-mirror/mneme - 65 events
klange/tales-of-darwinia - 63 events
esc/bottlepaste - 62 events
ehsan/mozilla-history-tools - 58 events
all4senses/Gv - 54 events
herry13/nuri - 51 events
SeqAlignViz/seqalignviz.github.com - 44 events
illcreative/Get-Home-Safe-NYC - 44 events
incxnt/incxnt.github.com - 41 events
daknok/Filmpje - 40 events
ChildOfWar/MIU - 40 events
aleontiev/Turntable.FM-Squared - 40 events
DigiZeit/dwa - 37 events
DigiZeit/dwa-debug - 37 events
danielcooper/radarsite - 37 events
navanjr/kts - 36 events
githubtrainer/poems - 35 events
wikimedia/mediawiki-extensions - 35 events
DigiZeit/dwa-pro - 35 events
gerritwm/MediaWiki - 34 events
cloudweekhec/stack - 34 events
andyisimprovised/goatmachine - 34 events
GreenplumChorus/chorus - 33 events
ros-gbp/nodelet_core-release - 33 events
honovation/veil - 33 events
McGill-CSB/PHYLO - 32 events
ceph/ceph - 31 events
aaronlbloom/dwa - 31 events
dotCMS/dotCMS - 31 events
RC5Group6/research-camp-5 - 30 events
ShreyaPandita/oftest - 30 events
```

## Going further

* There are [18 published Event Types](http://developer.github.com/v3/activity/events/types/). How would you manage them? What would you do if GitHub added more Event Types?
* What factors impact performance? What would you do to improve them?
* The example shows one type of output report. How would you add additional reporting formats?
* If you had to implement this using only one gem, which would it be? Why?
