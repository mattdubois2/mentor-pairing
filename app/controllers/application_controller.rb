class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def user_params
    [:first_name, :last_name, :twitter_handle, :email, :bio, :interests, :gravatar_url].inject({}) { |hash, attribute| hash.merge(attribute => params[attribute]) }
  end

end
