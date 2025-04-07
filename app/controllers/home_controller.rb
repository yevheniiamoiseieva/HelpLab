class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard]

  def dashboard
    render html: "<h1>Welcome, #{current_user.email}!</h1><a href='#{destroy_user_session_path}' data-turbo-method='delete'>Sign Out</a>".html_safe
  end
end