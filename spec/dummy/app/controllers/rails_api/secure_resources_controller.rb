module RailsApi
  class SecureResourcesController < ApplicationController
    before_filter :authenticate_api_user!, only: [:create]

    def create
      render json: {secure: 'data'}
    end
  end
end
