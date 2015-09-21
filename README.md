# Emmortal website

This is another social network

## Installation

It's preferable that you'll use RVM for managing gems and ruby versions.

Clone this repo with `git@github.com:Rezonans/emmortal.git` and then `cd` into the project's directory.
Install appropriate version of ruby if you haven't installed it yet and create gemset for the project (according to **.ruby-version** and **.ruby-gemset**).

Install gems by running

    bundle install

Copy **.env.example** as **.env** and configure your database connection and other project settings inside this file.

Create database and run migrations:

    rake db:create
    rake db:migrate

Seed database with test data:

    rake db:seed

Start your server:

    rails server
