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

    @total_pretax = [p1, p2, p3, p4, p5].compact.reduce(:+)

    @p1_bill = post_tax_bill(p1)
    @p2_bill = post_tax_bill(p2)
    @p3_bill = post_tax_bill(p3)
    @p4_bill = post_tax_bill(p4)
    @p5_bill = post_tax_bill(p5)

    @p1_tip = individual_tip(p1)
    @p2_tip = individual_tip(p2)
    @p3_tip = individual_tip(p3)
    @p4_tip = individual_tip(p4)
    @p5_tip = individual_tip(p5)

    @p1_total = individual_total(@p1_bill, @p1_tip)
    @p2_total = individual_total(@p2_bill, @p2_tip)
    @p3_total = individual_total(@p3_bill, @p3_tip)
    @p4_total = individual_total(@p4_bill, @p4_tip)
    @p5_total = individual_total(@p5_bill, @p5_tip)

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

  def post_tax_bill(individual_sum)
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
end
