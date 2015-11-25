class WelcomeController < ApplicationController
  def index
  end

  def results
    params[:people]
    params[:pretax_bill]
    params[:tax]
    params[:tip]
  end
end
