This is another simple weblog app. I think I've written about 10 different ones over the years. I doubt that this will be the last.

I'm writing this one to get a better grasp on:

* Sinatra.rb <http://www.sinatrarb.com/>
* Haml <http://haml-lang.com/>
* Sass <http://sass-lang.com/>
* Datamapper <http://datamapper.org/doku.php>

We'll see how it goes.

GEMS & VERSIONS NEEDED:

* sinatra >= 0.9.4
* sinatra_more >= 0.3.29
* datamapper >= 0.10.2 (dm-core, dm-timestamps, dm-validations, and dm-aggregates)
* dm-pager >= 1.0.1
* do_mysql >= 0.10.0
* haml >= 2.2.16
* rdiscount >= 1.3.5

For testing, you'll also need:

* do_sqlite3 >= 0.10.0
* rack-test >= 0.5.3
* rspec >= 1.2.9
* factory_girl >= 1.2.3

SETTING IT UP:

1. Grab the code from Github
2. Move/copy config/database.db.sample => config/database.rb 
3. Fill in your DB credentials (host, user, pass, DB)
4. Create the DB if it does not already exist
5. Run "rake app:setup_files" to copy the base files live
6. a few more steps here..
7. Maybe don't try this yet. Let me make the setup a little better.

TODO:

* Caching (esp. RSS & sitemap)
