# G5 Authenticatable

G5 Authenticatable provides a default authentication solution for G5
Rails applications. This gem configures and mounts 
[Devise](https://github.com/plataformatec/devise) with a default User
model, using [OmniAuth](https://github.com/intridea/omniauth) to authenticate
to the G5 Auth server. Helpers are also provided to secure your API methods.

If you are already using Devise with your own model, this is not the
library you are looking for. Consider using the
[devise_g5_authenticatable](https://github.com/g5search/devise_g5_authenticatable)
extension directly.

If you have a stand-alone service without a UI, you may not need Devise at
all. Consider using the
[g5_authenticatable_api](https://github.com/g5search/g5_authenticatable_api)
library in isolation.

## Current Version

0.0.2

## Requirements

* [rails](https://github.com/rails/rails) >= 3.2

## Installation

1. Set the environment variable `DEVISE_SECRET_KEY` to the value
   generated by:

   ```console
   rake secret
   ```

2. Add this line to your application's Gemfile:

   ```ruby
   gem 'g5_authenticatable'
   ```

3. And then execute:

   ```console
   bundle
   ```

4. Run the generator:

   ```console
   rails g g5_authenticatable:install
   ```

   This creates a migration for the new g5_authenticatable_users
   table, and mounts the engine at `/g5_auth`.

5. Update your database:

   ```console
   rake db:migrate db:test:prepare
   ```

## Configuration

### Root route

Devise requires you to define a root route in your application's
`config/routes.rb`. For example:

```ruby
root :to => 'home#index'
```

### Registering your OAuth application

1. Visit the auth server admin console:
  * For development, visit https://dev-auth.g5search.com/admin
  * For production, visit https://auth.g5search.com/admin
2. Login as the default G5 admin (for credentials, see
   Brian Ricker or Chris Kraybill).
3. Click "New Application"
4. Enter a name that recognizably identifies your application.
5. Enter the redirect URI where the auth server should redirect
   after the user successfully authenticates. It will be
   of the form `http://<your_host>/g5_auth/users/auth/g5/callback`.

   For non-production environments, this redirect URI does not have to
   be publicly accessible, but it must be accessible from the browser
   where you will be testing (so using something like
   http://localhost:3000/users/auth/g5/callback is fine if your browser
   and client application server are both local).

   If you are using the production G5 Auth server, the redirect URI **MUST**
   use HTTPS.
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

## Usage

### Controller filters and helpers

G5 Authenticatable installs all of the usual devise controllers and helpers.
To set up a controller that requires authentication, use this before_filter:

```ruby
before_filter :authenticate_user!
```

To verify if a user is signed in, use the following helper:

```ruby
user_signed_in?
```

To access the model instance for the currently signed-in user:

```ruby
current_user
```

To access scoped session storage:

```ruby
user_session
```

### Route helpers

There are several generic helper methods for session and omniauth
URLs. To sign in:

```ruby
new_session_path(:user)
```

To sign out:

```ruby
destroy_session_path(:user)
```

There are also generic helpers for the OmniAuth paths, though you
are unlikely to ever use these directly. The OmniAuth entry point
is mounted at:

```ruby
g5_authorize_path(:user)
```

And the OmniAuth callback is:

```ruby
g5_callback_path(:user)
```

You may be more familiar with Devise's generated scoped URL helpers.
These are still available, but are isolated to the engine's namespace.
For example:

```ruby
g5_authenticatable.new_user_session_path
g5_authenticatable.destroy_user_session_path
```

### Access token ###

When a user authenticates, their OAuth access token will be stored on
the local user:

```ruby
current_user.g5_access_token
```

This is to support server-to-server API calls with G5 services that are
protected by OAuth.

### Securing a Grape API ###

The API helpers are primarily intended to secure
[Grape](https://github.com/intridea/grape) endpoints, but they are compatible
with any Rack-based API implementation.

If you include the `G5AuthenticatableApi::GrapeHelpers`, you can use the
`authenticate_user!` method to protect your API actions:

```ruby
class MyApi < Grape::API
  helpers G5AuthenticatableApi::GrapeHelpers

  before { authenticate_user! }

  # ...
end
```

If you have an ember application, no client-side changes are necessary to use a
secure API method, as long as the action that serves your ember app requires
users to authenticate with G5 via devise.

Any non-browser clients must use token-based authentication. In contexts where
a valid OAuth 2.0 access token is not already available, you may request a new
token from the G5 Auth server using
[g5_authentication_client](https://github.com/g5search/g5_authentication_client).
Clients may pass the token to secure API actions either in the HTTP
Authorization header, or in a request parameter named `access_token`.

For more details, see the documentation for
[g5_authenticatable_api](https://github.com/g5search/g5_authenticatable_api).

### Test Helpers ###

G5 Authenticatable currently only supports [rspec-rails](https://github.com/rspec/rspec-rails).
Helpers and shared contexts are provided for integration testing secure pages
and API methods.

#### Installation ####

To automatically mix in helpers to your feature and request specs, include the
following line in your `spec/spec_helper.rb`:

```ruby
require 'g5_authenticatable/rspec'
```

#### Feature Specs ####

The easiest way to use g5_authenticatable in feature specs is through
the shared auth context. This context creates a user (available via
`let(:user)`) and then authenticates as that user. To use the shared
context, simply include `:auth` in the RSpec metadata for your example
or group:

```ruby
context 'my secure context', :auth do
  it 'can access some resource' do
    visit('the place')
    expect(page).to ...
  end
end
```

If you prefer, you can use the helper methods from
`G5Authenticatable::Test::FeatureHelpers` instead of relying on the shared
context. For example:

```ruby
describe 'my page' do
  context 'with valid user credentials' do
    let(:my_user) { create(:g5_authenticatable_user, email: 'my.email@test.host') }
    before { stub_g5_omniauth(my_user) }

    it 'should display the secure page' do
      visit('the page')
      expect(page).to ...
    end
  end

  context 'with invalid OAuth credentials' do
    before { stub_g5_invalid_credentials }

    it 'should display an error' do
      visit('the page')
      expect(page). to ...
    end
  end

  context 'when user has previously authenticated' do
    let(:my_user) { create(:g5_authenticatable_user, email: 'my.email@test.host') }
    before { visit_path_and_login_with('some other path', my_user) }

    it 'should display the thing I expect' do
      visit('the page')
      expect(page).to ...
    end
  end
end
```

## Examples

### Protecting a particular controller action

You can use all of the usual options to `before_filter` for more fine-grained
control over where authentication is required. For example, to require
authentication only to edit a resource while leaving all other actions
unsecured:

```ruby
class MyResourcesController < ApplicationController
  before_filter :authenticate_user!, only: [:edit, :update]

  # ...
end
```

### Adding a link to sign in

In your view template, add the following:

```html+erb
<%= link_to('Login', new_session_path(:user)) %>
```

### Adding a link to sign out

In order to sign out, the link must not only have the correct path,
but must also use the DELETE HTTP method:

```html+erb
<%= link_to('Logout', destroy_session_path(:user), :method => :delete) %>
```

### Selectively securing API methods

To selectively secure an individual API method:

```ruby
class MyApi < Grape::API
  get :my_secure_action do
    authenticate_user!
    {message: 'secure action'}
  end

  get :anonymous_action do
    {message: 'hello world'}
  end
end
```

## Authors

* Maeve Revels / [@maeve](https://github.com/maeve)
* Rob Revels / [@sleverbor](https://github.com/sleverbor)

## Contributing

1. [Fork it](https://github.com/g5search/g5_authenticatable/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write your code and **specs**
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

If you find bugs, have feature requests or questions, please
[file an issue](https://github.com/g5search/g5_authenticatable/issues).

### Specs

Before running the specs for the first time, you will need to initialize the
database for the test Rails application.

```console
$ cp spec/dummy/config/database.yml.sample spec/dummy/config/database.yml
$ RAILS_ENV=test bundle exec rake app:db:setup
```

To execute the entire test suite:

```console
$ bundle exec rspec spec
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
