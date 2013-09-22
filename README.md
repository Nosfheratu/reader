[![Code Climate](https://codeclimate.com/github/pykih/reader.png)](https://codeclimate.com/github/pykih/reader)

# pykih reader

pykih reader is an open source feed reader aimed at being a community owned and community developed feed reading & sharing platform.

### Software Requirements

* Ruby 1.9.2
* Rails 3.2.13
* PostGreSql
* Twitter Bootstrap
* jQuery

### Getting your environment up

* git clone git://github.com/pykih/reader.git
* Take the file from db/first_migrate and put it into db/migrate
* rake db:migrate
* rails s
* Open another terminal and > rake jobs:work
* Sign in Google and you are good to go.

### Model Design Logic

* A user has many authentications. Currently, we are doing only Google OAuth login. Once we add Facebook, Twitter, etc. for login, their keys too will be stored in authentications model. It internally uses omniauth and devise gems for authentications.

* The Ref Folder holds feeds and their articles (entries). E.g. Ram and Joe could both be subscribing to Hacker News. But we will store Hacker News only once in Ref::Feed and all the articles from Hacker News only once each in Ref::Entry. Hence, Ref::Feed and Ref::Entry do not have user_id column and are reference tables.

* The fetch and major API or DELETE jobs are done through DelayedJobs in the folder jobs.

* Since both Ram and Joe are following Hacker News, both will have a row in MyFeed connecting Feed and User. Each article in Hacker news (entry) will have one row for each Ram and Joe in MyEntry.

* Each user can have tags or folders defined. Each tag can have multiple MyFeeds.

### What needs to be coded?

pykih reader is still new. We need major upgrades. Check out the issues under [Version 0.1 milestone](https://github.com/pykih/reader/issues?milestone=1&page=1&state=open). 

### Contributors

* [@fherxosc](https://twitter.com/fherxosc) - https://github.com/Nosfheratu
* [@mihirmodi](https://twitter.com/mihirmodi) - Designer, Marketing and Branding expert
* Arun Kumar - https://github.com/arunkumar1ly
* Ashay Rane - https://github.com/ashay
* Idyllic Software - www.idyllic-software.com
* [@pykih](https://twitter.com/pykih) - www.pykih.com