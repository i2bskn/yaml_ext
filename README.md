# YamlExt

[![Gem Version](https://badge.fury.io/rb/yaml_ext.svg)](https://badge.fury.io/rb/yaml_ext)
[![Build Status](https://travis-ci.org/i2bskn/yaml_ext.svg?branch=master)](https://travis-ci.org/i2bskn/yaml_ext)

`yaml_ext` provide references in YAML.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "yaml_ext"
```

And then execute:

```bash
$ bundle install
```

## Usage

```ruby
pry(main)> YamlExt.load("example/schema.yml")
=> {"openapi"=>"3.0.0",
 "info"=>{"version"=>"1.0.0", "title"=>"Example API", "description"=>2},
 "servers"=>[{"url"=>"http://example.com/v1"}],
 "paths"=>
  {"/users"=>
    {"get"=>
      {"summary"=>"List all users",
       "operationId"=>"listUsers",
       "tags"=>["users"],
       "parameters"=>[{"name"=>"limit", "in"=>"query", "description"=>"How many items to return at one time (max 100)", "required"=>false, "schema"=>{"type"=>"integer"}}],
       "responses"=>
        {"200"=>
          {"description"=>"A paged array of users",
           "headers"=>{"x-next"=>{"description"=>"A link to the next page of responses", "schema"=>{"type"=>"string"}}},
           "content"=>{"application/json"=>{"schema"=>{"type"=>"array", "items"=>{"type"=>"object", "required"=>["id", "name"], "properties"=>{"id"=>{"type"=>"integer"}, "name"=>{"type"=>"string"}, "tag"=>{"type"=>"string"}}}}}}},
         "default"=>{"description"=>"unexpected error", "content"=>{"application/json"=>{"schema"=>{"type"=>"object", "required"=>["code", "message"], "properties"=>{"code"=>{"type"=>"integer"}, "message"=>{"type"=>"string"}}}}}}}},
     "post"=>
      {"summary"=>"Create a user",
       "operationId"=>"createUsers",
       "tags"=>["users"],
       "responses"=>
        {"201"=>{"description"=>"Null response"},
         "default"=>{"description"=>"unexpected error", "content"=>{"application/json"=>{"schema"=>{"type"=>"object", "required"=>["code", "message"], "properties"=>{"code"=>{"type"=>"integer"}, "message"=>{"type"=>"string"}}}}}}}}},
   "/users/{userId}"=>
    {"get"=>
      {"get"=>
        {"summary"=>"Info for a specific user",
         "operationId"=>"showUserById",
         "tags"=>["users"],
         "parameters"=>[{"name"=>"userId", "in"=>"path", "description"=>"The id of the user", "required"=>true, "schema"=>{"type"=>"integer"}}],
         "responses"=>
          {"200"=>{"description"=>"Expected response to a valid request", "content"=>{"application/json"=>{"schema"=>{"type"=>"object", "required"=>["id", "name"], "properties"=>{"id"=>{"type"=>"integer"}, "name"=>{"type"=>"string"}, "tag"=>{"type"=>"string"}}}}}},
           "default"=>{"description"=>"unexpected error", "content"=>{"application/json"=>{"schema"=>{"type"=>"object", "required"=>["code", "message"], "properties"=>{"code"=>{"type"=>"integer"}, "message"=>{"type"=>"string"}}}}}}}}}}},
 "components"=>
  {"schemas"=>
    {"User"=>{"type"=>"object", "required"=>["id", "name"], "properties"=>{"id"=>{"type"=>"integer"}, "name"=>{"type"=>"string"}, "tag"=>{"type"=>"string"}}},
     "Users"=>{"type"=>"array", "items"=>{"type"=>"object", "required"=>["id", "name"], "properties"=>{"id"=>{"type"=>"integer"}, "name"=>{"type"=>"string"}, "tag"=>{"type"=>"string"}}}},
     "Error"=>{"type"=>"object", "required"=>["code", "message"], "properties"=>{"code"=>{"type"=>"integer"}, "message"=>{"type"=>"string"}}}}}}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/i2bskn/yaml_ext.
