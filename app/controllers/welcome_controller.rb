class WelcomeController < ApplicationController
  def index
  end

  def results
    @people = params[:people]
    pretax_bill = params[:pretax_bill]
    tax = params[:tax]
    tip = params[:tip]
  end
end
