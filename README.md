# HelperChain

[![Stories in Ready](https://badge.waffle.io/refugeehackathon/helperchain.svg?label=ready&title=Ready)](http://waffle.io/refugeehackathon/helperchain)

Intelligent mailing list for organizing help

https://github.com/refugeehackathon/helperchain

# Contact us!

http://helperchain.org

hallo@helperchain.org

# Technology used

* Ruby on Rails
* PostgreSQL
* Redis

# Contributing

## Get the source

We are using [Gerrit](https://www.gerritcodereview.com/) for Code
review. Please spent the tree minutes more you need to set it up:

1. [Register here](https://gerrit.azapps.de/r/login/) (Please do not
   use GitHub because they do not share your E-Mail and Gerrit needs
   it :( )
2. [Set your user name](https://gerrit.azapps.de/r/#/settings/)
3. [Add your SSH key](https://gerrit.azapps.de/r/#/settings/ssh-keys)
4. [Clone the project](https://gerrit.azapps.de/r/#/admin/projects/helperchain/backend)
  → **SSH + clone with commit hook**

## Configuration

Rename `example_.env.development` to `.env.development` (don't forget
the dot in front) and edit it accordingly.

## Install dependencies

* Ruby (e.g. using [RVM](http://rvm.io/))
* [PostgreSQL](http://www.postgresql.org/) (As the database)
* [Redis](http://redis.io/) (For Job queues)

```sh
$ gem install bundler # Optional – only if `bundle` does not work
$ bundle
$ bundle exec rake db create # optionally – only if the database is not created
```

If you have problems with V8 – just comment the following line in the
`Gemfile`: `gem 'therubyracer', platforms: :ruby`

## Run the server

### Automatically

```sh
$ ./start_development.sh
```

Visit http://localhost:3000

### Manually

```sh
$ bundle exec rake db migrate
$ bundle exec rails server -p 3000
```

Now start the [sidekiq](http://sidekiq.org/) Server (otherwise the
mails won't be delivered):

```
$ bundle exec sidekiq
```

Visit http://localhost:3000

## Fix whatever you want to fix

See the [issues](https://github.com/refugeehackathon/helperchain/issues) or
[waffle.io](https://waffle.io/refugeehackathon/helperchain) if you do
not know what to do ;)

## Push it to Gerrit

You can not push directly to the `master` branch, but you have to push
to the `refs/for/master` branch:

```
git push origin HEAD:refs/for/master
```

That's all, now you can view your change in the [web interface](https://gerrit.azapps.de/r/#/q/status:open)


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
