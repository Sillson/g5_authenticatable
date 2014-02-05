# G5 Authenticatable

G5 Authenticatable provides a default authentication solution for G5
Rails applications. This gem configures and mounts 
[devise](https://github.com/plataformatec/devise) with a default User
model.

If you are already using devise with your own model, this is not the
library you are looking for. Consider using the
[devise_g5_authenticatable](https://github.com/g5search/devise_g5_authenticatable)
extension directly instead.

## Current Version

0.0.1 (unreleased)

## Requirements

* [rails](https://github.com/rails/rails) >= 3.2

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'g5_authenticatable'
```

And then execute:

```console
bundle
```

After you install the gem, you'll need to run the generator:

```console
rails generate g5_authenticatable
```

You'll also need to run a rake task to install the migrations:

```console
rake g5_authenticatable:install:migrations
```

## Configuration

### Root route

Devise requires you to define a root route in your `config/routes.rb`.
For example:

```ruby
root :to => 'home#index'
```

### Registering your OAuth application

1. Visit the auth server admin console:
  * For development, visit https://dev-auth.g5search.com/admin
  * For production, visit https://auth.g5search.com/admin
2. Login as the default admin (for credentials, see
   Brian Ricker or Chris Kraybill).
3. Click "New Application"
4. Enter a name that recognizably identifies your application.
5. Enter the redirect URI where the auth server should redirect
   after the user successfully authenticates. It will generally be
   of the form `http://<apphost>/<devise_path>/auth/g5/callback`.

   For non-production environments, this redirect URI does not have to
   be publicly accessible, but it must be accessible from the browser
   where you will be testing (so using something like
   http://localhost:3000/users/auth/g5/callback is fine if your browser
   and client application server are both local).
6. For a trusted G5 application, check the "Auto-authorize?" checkbox. This
   skips the OAuth authorization step where the user is prompted to explicitly
   authorize the client application to access the user's data.
7. Click "Submit" to obtain the client application's credentials.

### Environment variables

Once you have your OAuth 2.0 credentials, you'll need to set the following
environment variables for your client application:

* `G5_AUTH_CLIENT_ID` - the OAuth 2.0 application ID from the auth server
* `G5_AUTH_CLIENT_SECRET` - the OAuth 2.0 application secret from the auth server
* `G5_AUTH_REDIRECT_URI` - the OAuth 2.0 redirect URI registered with the auth server
* `G5_AUTH_ENDPOINT` - the endpoint URL for the G5 auth server
* `DEVISE_SECRET_KEY` - generate a unique secret key for your app using `rake secret`

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
