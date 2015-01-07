# Gem in a Strong Box

Gem in a Strong Box is a Ruby on Rails application that wraps [Gem in a Box](https://github.com/geminabox/geminabox).

You get all of the goodness from Gem in a Box with some added features:

* Protected Gem server to prevent outsiders from accessing your gems.
* A simple front-end to manage the users that have access to your gems.
* Google authentication on the front-end

## Installing and Running

```
git clone https://github.com/zendesk/geminastrongbox.git
cd geminastrongbox
bundle install
rails s
```

Getting the basic server running locally is very easy. Simply clone the repository, bundle the dependencies, and run the server.

If the environment variable `SKIP_FORCE_SSL` is set the server will not force ssl on the connections.

### Running in Production

If you want to run Gem in a Stong Box in prodcution, you probably want to make a few changes. Here are my suggestions:

1. Use a different database. Per default Gem in a Strong Box uses a SQLite database. This is simply for ease of development and test. In production I would use a MySQL or PostgreSQL server. Just change the configuration in `config/database.yml` and add the appropriate gem to the `Gemfile`.
2. Set __all__ of the configuration options listed below.

## Configuration

Configuration is done via environment variables

Variable Name          | Description
---------------------- | -------------
`SECRET_KEY_BASE`      | Ruby on Rails uses this to encrypt sessions and cookies.
`DATA_PATH`            | The path where the hosted gems should be stored.
`GOOGLE_CLIENT_ID`     | The client id obtained from Google.
`GOOGLE_CLIENT_SECRET` | The client secret obtained from Google.
`GOOGLE_DOMAIN`        | The domain that should have access to your gems. Only users with an email on this domain will have access to your gems.

## Copyright and License

Copyright 2014 Zendesk

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
