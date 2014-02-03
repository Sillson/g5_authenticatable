# G5 Authenticatable

G5 Authenticatable provides a default authentication solution for G5
Rails applications.

## Current Version

0.0.1 (unreleased)

## Requirements

* [rails](https://github.com/rails/rails) >= 3.2
* [devise](https://github.com/plataformatec/devise) ~> 3.1
* [devise_g5_authenticatable](https://github.com/g5search/devise_g5_authenticatable)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'g5_authenticatable'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install g5_authenticatable
```

## Usage

TODO: Write usage instructions here

### Devise setup

Some setup you must do manually if you haven't yet:

1. Ensure you have defined default url options in your environments files. Here
   is an example of `default_url_options` appropriate for a development environment
   in `config/environments/development.rb`:

    ```ruby
    config.action_mailer.default_url_options = { :host => 'localhost:3000' }
    ```

   In production, `:host` should be set to the actual host of your application.

2. Ensure you have defined root_url to *something* in your `config/routes.rb`.
   For example:

    ```ruby
    root :to => "home#index"
    ```

3. Ensure you have flash messages in `app/views/layouts/application.html.erb`.
   For example:

    ```html+erb
    <p class="notice"><%= notice %></p>
    <p class="alert"><%= alert %></p>
    ```

4. If you are deploying on Heroku with Rails 3.2 only, you may want to set:

    ```ruby
    config.assets.initialize_on_precompile = false
    ```

   in `config/application.rb` forcing your application to not access the DB
   or load models when precompiling your assets.

5. You can copy Devise views (for customization) to your app by running:

    ```bash
    rails g devise:views
    ```

## Examples

TODO: Write examples here

## Authors

* Maeve Revels / [@maeve](https://github.com/maeve)

## Contributing

1. Fork it ( http://github.com/<my-github-username>/g5_authenticatable/fork )
2. Get it running (see Installation above)
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Write your code and **specs**
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request

If you find bugs, have feature requests or questions, please
[file an issue](https://github.com/g5search/g5_authenticatable/issues).

### Specs

Before running the specs for the first time, you will need to initialize the
database for the test Rails application.

```bash
$ bundle exec rake app:db:setup
```

To execute the entire test suite:

```bash
$ bundle exec rake
```

## License

Copyright (c) 2014 G5

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
