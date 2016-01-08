class WelcomeController < ApplicationController
  before_action :validate_form, only: :results

  def index
  end

  def even_results
    @people = params[:people].to_i
    pretax_bill = params[:pretax_bill].to_f
    tax = params[:tax].to_f
    tip = params[:tip].to_f
    split_tax = tax / @people

    @split_bill = (pretax_bill / @people + split_tax)
    @split_tip = (pretax_bill * (tip / 100) / @people)

    @split_bill = 0 if @split_bill.nan?
    @split_tip = 0 if @split_tip.nan?

    @split_total = @split_bill + @split_tip
  end

  def uneven_split
    @number_of_people = params[:people].to_i
  end

  def uneven_results
    @number_of_people = params[:people].to_i
    @tax = params[:tax].to_f
    @tip_percentage = params[:tip].to_f

    individual_amounts = {}

    for i in 1..@number_of_people do
      individual_amounts[i] = params[:"p#{i}"]
    end

    diner_pretax_amounts = individual_amounts.values.map do |values_array|
      values_array.split.map(&:to_f).reduce(:+).to_f
    end

    @total_pretax = diner_pretax_amounts.reduce(:+).to_f

    @group_bill = diner_pretax_amounts.map do |amount|
      {individual_bill: individual_post_tax(amount), individual_tip: individual_tip(amount), individual_total: (individual_post_tax(amount).to_f + individual_tip(amount).to_f)}
    end

    @total_pretip = @total_pretax + @tax
    @total_tip = @total_pretax * (@tip_percentage / 100)
    @overall_total = @total_pretip + @total_tip

  end

  private

  def validate_form
  end

  def sum_entry(entry)
    entry.split.map(&:to_f).reduce(:+)
  end

  def individual_post_tax(individual_sum)
    individual_sum + @tax * (individual_sum / @total_pretax) if individual_sum
  end

  def individual_tip(individual_sum)
    ((@tip_percentage / 100) * individual_sum) if individual_sum
  end

  def diner_bill_hash(individual_bill, individual_tip, individual_total)
  end
end
