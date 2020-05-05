# Students For Kids
Students For Kids is a platform which @Fritz Meyer and @Fritz Schack built as a semester project at CODE University, Berlin. The platform functions as a mean to help parents find young students willing to volunteer as babysitters. The platform is based on Ruby on Rails with a PostgreSQL database.

## Install
Students For Kids requires the latest version of [Ruby](https://www.ruby-lang.org/en/) and [Rails](https://rubyonrails.org/).

### Clone the repository

```shell
git clone git@github.com:meyerfr/students4kids.git
cd project
```

### Check your Ruby version

```shell
ruby -v
```

The ouput should start with something like `ruby 2.5.1`

If not, install the right ruby version using [rbenv](https://github.com/rbenv/rbenv) (it could take a while):

```shell
rbenv install 2.5.1
```

### Install dependencies

Using [Bundler](https://github.com/bundler/bundler) and [Yarn](https://github.com/yarnpkg/yarn):

```shell
bundle && yarn
```

### Initialize the database

```shell
rails db:create db:migrate db:seed
```

## Serve

```shell
rails s
```
