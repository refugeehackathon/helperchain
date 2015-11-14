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

# License

Copyright (c) 2015 Christian Knebel, Walter Forkel, Anatoly Zelenin


    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
