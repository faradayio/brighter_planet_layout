class PagesController < ApplicationController
  def index
    @title = 'Home'
    render :template => 'pages/index'
  end
end
