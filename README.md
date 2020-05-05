# Students For Kids
Students For Kids is a platform which @Fritz Meyer and @Fritz Schack built as a semester project at CODE University, Berlin. The platform functions as a mean to help parents find young students willing to volunteer as babysitters. The platform is based on Ruby on Rails with a PostgreSQL database.

## Install
Students For Kids requires the latest version of [Ruby](https://www.ruby-lang.org/en/) and [Rails](https://rubyonrails.org/).

### Clone the repository

```shell
git clone git@github.com:meyerfr/students4kids.git students4kids
cd students4kids
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

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Built With

* [Ruby](https://www.ruby-lang.org/en/)
* [Rails](https://rubyonrails.org/) - Web Framework
* [PostgreSQL](https://postgesql.org) - Database System

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **[Fritz Meyer](https://github.com/meyerfr)**
* **[Friedrich Schack](https://github.com/fritzschack)** - 

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.
