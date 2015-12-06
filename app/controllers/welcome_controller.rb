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

  def uneven_split
  end

  def uneven_results
    @tax = params[:tax].to_f
    @tip_percentage = params[:tip].to_f

    p1 = sum_entry(params[:p1])
    p2 = sum_entry(params[:p2])
    p3 = sum_entry(params[:p3])
    p4 = sum_entry(params[:p4])
    p5 = sum_entry(params[:p5])

    diner_pretax_amounts = [p1, p2, p3, p4, p5].compact
    @total_pretax = diner_pretax_amounts.reduce(:+)

    @group_bill = diner_pretax_amounts.map do |amount|
      {individual_bill: individual_post_tax(amount), individual_tip: individual_tip(amount), individual_total: (individual_post_tax(amount).to_f + individual_tip(amount).to_f)}
    end

    @total_pretip = @total_pretax + @tax
    @total_tip = @total_pretip * (@tip_percentage / 100)
    @overall_total = @total_pretip + @total_tip

  end

  private

  def validate_form
  end

  def sum_entry(entry)
    entry.split.map(&:to_f).reduce(:+)
  end

  def individual_post_tax(individual_sum)
    individual_sum + @tax * (individual_sum / @total_pretax).round(2) if individual_sum
  end

  def individual_tip(individual_sum)
    ((@tip_percentage / 100) * individual_sum).round(2) if individual_sum
  end

  def individual_total(individual_bill, individual_tip)
    if individual_bill && individual_tip
      (individual_bill + individual_tip).round(2)
    end
  end

  def diner_bill_hash(individual_bill, individual_tip, individual_total)
  end
end
