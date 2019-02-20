Let's consider deployment of new development/testing environment of a Website, which uses database. Let's assume we want to test behavior with newly released version of MariaDB.
In human language may look like this: (for simplicity let's assume that all system dependencies are met on this machine).

1. Clone the website sources from github
2. Build / prepare website sources.
3. Download MariaDB .tar distribution and setup it (initialize data directory, load backup, etc)
4. Configure website to database
5. Start database
6. Start website
7. Check that both Db and website are up

Let's assume we performed all steps above and found a problem, but you are not fully sure if it is real bug or issue with your environment. So you tried all the step in docker, but met different issue. This irritates a bit, so you asked help from a colleague, who also performed the same steps and confirmed that the problem indeed there. So you reported it to MariaDB Engineer, who was willing to help. Let's assume MariaDB Engineer successfully retried the same and confirmed that the issue happens only in the latest version. Now she tried the same, just building MariaDB from source in step 3. and during debugging a simple workaround was found. So you tried the steps again and were able to confirm that workaround is good and your Website works well with new MariaDB version.

The example above is very simplified version of what actually happens. Single mystery happened in Docker, but on practice small difference in each step may lead to different outcome. Moreover - each step takes a bit from brain resources and one day can fit quite limited number of such scenarios for single engineer.

If both the Website and MariaDB had Environs defined (let's name them w1 and m1), the whole scenario would look like few lines in shell script, which leaves little chance for discrepancy in behavior. The same steps may look like:
```set -e
w1/clone.sh
w1/build.sh
m1/download.sh && m1/init_db.sh
w1/configure.sh m1
m1/start.sh
w1/start.sh
m1/status.sh && w1/status.sh```

Note that to build MariaDB from source instead of downloading .tar distribution, one would have different Environ with commands like m1/clone.sh && m1/build.sh && m1/init_db.sh

Maybe so far usage on Environs is not impressive, but it must be for sure justified when we complicate scenario further. Like comparing behavior when using different Website forks or using MariaDB Cluster or MariaDB with encryption with alternative database like Oracle/MySQL/PostgreSQL or intermediate configuration steps. If we can create Environ with these simple scripts like start.sh / status.sh / init_db.sh / etc for each involved Database diversity - the scripting will be very easy and robust.
