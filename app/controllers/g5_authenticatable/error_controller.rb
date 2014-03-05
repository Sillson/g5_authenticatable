module G5Authenticatable
  class ErrorController < ApplicationController

    def auth_error
      flash[:error] = 'There was a problem with the Auth Server!'
    end

  end
end
