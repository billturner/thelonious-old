This is another simple weblog app. I think I've written about 10 different ones over the years. I doubt that this will be the last.

I'm writing this one to get a better grasp on:

* Sinatra.rb <http://www.sinatrarb.com/>
* Haml <http://haml-lang.com/>
* Sass <http://sass-lang.com/>
* MongoDB <http://mongodb.org/> & MongoMapper <http://github.com/jnunemaker/mongomapper/>

We'll see how it goes.

GEMS & VERSIONS NEEDED:

* sinatra >= 0.9.4 (works with 1.0!)
* sinatra_more >= 0.3.29
* mongo_mapper >= 0.6.10 (and its dependencies)
* haml >= 2.2.16
* rdiscount >= 1.3.5
* active_support (from Rails, probably version > 2.0)
* rack-flash

For testing, you'll also need:

* rack-test >= 0.5.3
* rspec >= 1.2.9
* factory_girl >= 1.2.3
* webrat >= 0.6.0

SETTING IT UP:

1. Grab the code from Github
2. Run "rake app:setup" to copy the base example files
3. Fill in your MongoDB information in lib/database.rb
4. Adjust the settings (like admin user & pass) in config/settings.rb
5. To get the app started from the command line, use rackup: `rackup -p 4567 config.ru`
6. Pull it up in the browser <http://localhost:4567/> and login to start adding posts: <http://localhost:4567/login>
7. For hosting the app, I would suggest using Phusion Passenger: <http://www.modrails.com/>

TODO:

* Caching (esp. RSS & sitemap)
* Pull sinatra_more code into a local lib (since sinatra_more has been all but abandoned for Padrino)