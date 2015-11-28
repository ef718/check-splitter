class WelcomeController < ApplicationController
  before_action :validate_form, only: :results

  def index
  end

  def results
    @people = params[:people].to_i
    pretax_bill = params[:pretax_bill].to_f
    tax = params[:tax].to_f
    tip = params[:tip].to_f
    split_tax = tax / @people
    @split_bill = (pretax_bill / @people + split_tax).round(2)

    @split_tip = (pretax_bill * (tip / 100) / @people).round(2)
    @split_total = @split_bill + @split_tip
  end

  private

  def validate_form
  end
end
