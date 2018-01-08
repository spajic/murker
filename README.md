# Murker

[![Build Status](https://travis-ci.org/spajic/murker.svg?branch=master)](https://travis-ci.org/spajic/murker)

Murker detects changes in schemas of Rails API-interactions in json-format.

To use murker, tag spec having API-interaction with `:murker` tag.

In first run murker will generate and save schema of interaction in Open API v3 format [https://swagger.io/docs/specification/about/].

Next time it will validate an interaction against stored schema and fail if schema has changed.

## Usage
Let's say we have nested resource Martians/Pets in V1 namespace.

We can write a request-spec and tag it with `:murker` tag:

```ruby
require 'rails_helper'
require 'murker/spec_helper'

RSpec.describe V1::PetsController, type: :request do

  describe "GET pet" do
    it "returns a success response", :murker do
      martian = Martian.create! name: 'spajic', age: 30, id: 1
      martian.pets.create! name: 'chubby', weight: 10, id: 1

      get '/v1/martians/1/pets/1.json'

      expect(response).to be_success
    end
  end
end
```

After first run `murker` will generate OAS3 schema and dump it to `/spec/murker/v1/martians/__martian_id/pets/__id/GET.yml`

```yml
---
openapi: 3.0.0
info:
  title: Generated by Murker
  version: 0.1.0
paths:
  "/v1/martians/{martian_id}/pets/{id}":
    get:
      parameters:
      - in: path
        name: martian_id
        description: martian_id
        schema:
          type: integer
        required: true
        example: '1'
      - in: path
        name: id
        description: id
        schema:
          type: integer
        required: true
        example: '1'
      responses:
        "'200'":
          description: GET /v1/martians/:martian_id/pets/:id -> 200
          content:
            application/json:
              schema:
                type: object
                required:
                - name
                - weight
                properties:
                  name:
                    type: string
                  weight:
                    type: integer
```

This schema can be supplied to swagger. [https://editor.swagger.io/]

![swagger screenshot](https://www.dropbox.com/s/lr0id1scfioicre/murker-swagger.png?raw=1 "Swagger screenshot")

Let's say we accedentally changed schema of response. For example, `weight` property was removed.

In that case murker will fail test with following message. Note it says what have actually changed.
```
Murker::ValidationError:
  MURKER VALIDATION FAILED!

  Interaction 'GET /v1/martians/:martian_id/pets/:id' failed with the following reason:
  [{"op"=>"remove", "path"=>"/paths/~1v1~1martians~1{martian_id}~1pets~1{id}/get/responses/'200'/content/application~1json/schema/required/1", "was"=>"weight"}, {"op"=>"remove", "path"=>"/paths/~1v1~1martians~1{martian_id}~1pets~1{id}/get/responses/'200'/content/application~1json/schema/properties/weight", "was"=>{"type"=>"integer"}}]
```


## Installation
Add this line to your application's Gemfile:

```ruby
group :test
  gem 'murker'
end
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install murker

```ruby
require 'murker/spec_helper' # in your specs
```

## Features
- TravisCI integration
- Rspec tests and Cucumber tests via prepared rails 5.1 test-app
- Generation of valid OAS3 schema
- Support to capture multiple interactions per block
- Support tag (`:murker`) and block (`Murker.capture {}`) syntax
- Diff of schemas via `json-diff` gem [https://github.com/espadrine/json-diff]

## TODO
- Support and test different versions of rails and ruby
- Support minitest
- Automatically validate generated schemas against OAS3 spec
- Handle compatible and incompatible changes of schema differently
- Allow non-necessary attributes to vary (require only necessary attributes to be equal)
- Generate schema for form-encoded params?
- Generate more OAS3 schema attributes?
- Refactor
- Improve Readme

## Limitations
- Capture maximum 1 interaction in `:controller` spec (see https://github.com/rails/rails/issues/13851)
- Only support `application/json` interactions yet

## Development
To run cucumber specs:

```bash
bundle exec appraisal install
bundle exec appraisal rails-5 cucumber
rm -r spec/murker && bundle exec appraisal reils-5 cucumber
```

To run rspec specs:

```bash
rspec
```

You can also run prepared test app:
```bash
cd test_apps/rails_51
rails s
```

And you can run specs of prepared test app:
```bash
cd test_apps/rails_51
rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aderyabin/murker. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Murker project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/aderyabin/murker/blob/master/CODE_OF_CONDUCT.md).
