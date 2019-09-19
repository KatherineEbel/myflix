# frozen_string_literal: true

# pages_controller.rb
class PagesController < ApplicationController
  def front
    redirect_to home_path if logged_in?
  end
end
