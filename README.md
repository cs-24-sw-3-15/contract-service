# contract-service

## Ruby version
- `ruby3.3`

Good idea to use something like `rbenv` to install ruby.

## Gem system dependencies
- [ruby-dev](https://pkgs.org/search/?q=ruby-dev)
- [`libyaml-dev`](https://pkgs.org/search/?q=libyaml)
- [`libvips-dev`](https://pkgs.org/search/?q=libvips)
- [mupdf](https://pkgs.org/search/?q=mupdf)

## Gem configuration
```bash
bundle config set --local path vendor/bundle
bundle install
```

## Database creation
```bash
bin/rails db:migrate
```

## Run Puma Development Server
```bash
bin/rails server
```

## Things Left to do

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
