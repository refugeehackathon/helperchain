# HelperChain

Intelligent mailing list for organizing help

https://github.com/refugeehackathon/helperchain

# Contact us!

http://helperchain.org

hallo@helperchain.org

# Technology used

* Ruby on Rails
* PostgreSQL
* Redis

# Getting started in 2 minutes

## Dependencies

* Ruby (e.g. using [RVM](http://rvm.io/))
* [PostgreSQL](http://www.postgresql.org/) (As the database)
* [Redis](http://redis.io/) (For Job queues)

```sh
$ gem install bundler # Optional – only if `bundle` does not work
$ bundle
```

## Configuration

Rename `example_.env.development` to `.env.development` (don't forget
the dot) and edit it accordingly.

## Run the server

### Automatically

```sh
$ ./start_development.sh
```

Visit http://localhost:3000

### Manually

```sh
$ bundle exec rake db create # optionally – only if the database is not created
$ bundle exec rake db migrate
$ bundle exec rails server -p 3000
```

Now start the [sidekiq](http://sidekiq.org/) Server (otherwise the
mails won't be delivered):

```
$ bundle exec sidekiq
```

Visit http://localhost:3000
