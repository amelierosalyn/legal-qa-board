# README

## Legal Q&A board

### Setup

Requirements:

* Ruby 3.4
* Rails 8.1.3
* PostgreSQL 18

To install, clone the repo then run:

```
gem install bundler
bundle install
bin/rails db:prepare
bin/rails db:seed
bin/rails server
```

To run tests:

```
bin/rails db:prepare RAILS_ENV=test
bundle exec rspec spec
```

### Development process

Development was roughly 75% manual and 25% AI-assisted via IDE code completion.

### Stretch goals accomplished

* Applied simple formatting to questions and answers
* Allowed questions to be deleted (own idea)

### With more time I would...

* Improve the UI - not fully satisfied with colour scheme
* Improve interactions - feels "clunky" at present
* Accomplish further stretch goals
* Refactor code to be more efficient, reduce db calls and rendering
* Add a proper login system for users and lawyers