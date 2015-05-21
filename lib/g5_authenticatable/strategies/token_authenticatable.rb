require 'devise/strategies/authenticatable'

module G5Authenticatable
  module Strategies
    class TokenAuthenticatable < Devise::Strategies::Authenticatable
      # A valid strategy for token_authenticatable needs an access
      # token in the request
      def valid?
        auth_user_fetcher.access_token.present?
      end

      # To authenticate a user, we look up the auth user data and then
      # find or create a corresponding local user
      def authenticate!
        auth_user = auth_user_fetcher.current_user
        binding.pry
        resource = mapping.to.find_by_provider_and_uid('g5', auth_user.uid)
      end

      private
      def auth_user_fetcher
        request_headers = ActionDispatch::Http::Headers.new(env)
        @auth_user_fetcher ||= G5AuthenticatableApi::Services::UserFetcher.new(
          request.params, request_headers)
      end
    end
  end
end

Warden::Strategies.add(:g5_token_authenticatable, G5Authenticatable::Strategies::TokenAuthenticatable)
