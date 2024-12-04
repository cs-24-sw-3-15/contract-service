# contract-service

## Ruby version
Ruby 3.3

## Gem system dependencies
- [`ruby-dev`](https://pkgs.org/search/?q=ruby-dev)
- [`libyaml-dev`](https://pkgs.org/search/?q=libyaml)
- [`libvips-dev`](https://pkgs.org/search/?q=libvips)
- [`mupdf`](https://pkgs.org/search/?q=mupdf)

## Install Guide

First install `rbenv`:
```bash
# MacOS
brew install rbenv
# Ubuntu Linux
sudo apt install rbenv libyaml-dev libvips-dev mupdf
```

Then install `rbenv`:
```bash
rbenv init
# Now follow its instructions to complete the installation.
```

Go into your project and write the following commands:
```bash
rbenv install 3.3.6
rbenv local 3.3.6
```

Run `ruby --version` to verify that its now on version `3.3.6`.

Now go to Gem configuration to continue.

## Gem configuration

Set up where gems should be installed, then install the dependencies.

```bash
bundle config set --local path vendor/bundle
bundle install
```

## Database creation

Initializes and migrates the database (sqlite) to the latest revision
available in the project.

```bash
bin/rails db:create
bin/rails db:migrate
```

## Database initialization

For testing, there is some example data already generated for you in
`db/seeds.db`. To use it write the following.
```bash
bin/rails db:seed
```

Further, there is a huge amount of premade labels inside `credentials.yml.enc`,
which you can access if you have configured `config/master.key`. Ask frequent
contributors for this file if you need these premade labels. These labels may
also be used in production.

```bash
bin/rails db:custom_seed
```

## Run Puma Development Server

```bash
bin/rails server
```

## Deployment to Production Environment

See [PRODUCTION.md](./PRODUCTION.md)

## Things Left to do

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* ...
