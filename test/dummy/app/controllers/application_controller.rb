class ApplicationController < ActionController::Base
  helper TronprintHelper
  protect_from_forgery
end
