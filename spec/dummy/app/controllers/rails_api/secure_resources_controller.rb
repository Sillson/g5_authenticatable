module RailsApi
  class SecureResourcesController < ApplicationController
    before_filter :authenticate_api_user!, unless: :is_navigational_format?
    before_filter :authenticate_user!, if: :is_navigational_format?

    def create
      render json: {secure: 'data'}
    end

    def show
      respond_to do |format|
        format.html { render }
        format.json { render json: {secure: 'data'} }
      end
    end
  end
end
