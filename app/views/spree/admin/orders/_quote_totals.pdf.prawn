payment = []
cc_type = {"discover" => "Discover", "master" => "MasterCard", "visa" => "Visa", "amex" => "AmEx"}

payment << [Prawn::Table::Cell.new( :text => "Invoice State:", :font_style => :bold), @order.payment_state.try(:titleize)]
unless @order.payments.blank?
    if @order.payments.last.source_type == "Spree::CreditCard"
      payment << [Prawn::Table::Cell.new( :text => "Payment Method:", :font_style => :bold), "Credit Card"]
      payment << [Prawn::Table::Cell.new( :text => "Card Type:", :font_style => :bold), "#{cc_type[@order.payments.last.source.cc_type]} ending in #{@order.payments.last.source.last_digits}"]
    end
    if @order.payments.last.source_type == "Spree::PaypalAccount"
      payment << [Prawn::Table::Cell.new( :text => "Payment Method:", :font_style => :bold), "PayPal"]
      payment << [Prawn::Table::Cell.new( :text => "PayPal Email:", :font_style => :bold), "#{@order.payments.last.source.email}"]
    end
    if @order.payments.last.source_type == "Spree::DwollaCheckout"
      payment << [Prawn::Table::Cell.new( :text => "Payment Method:", :font_style => :bold), "Dwolla"]
      payment << [Prawn::Table::Cell.new( :text => "Dwolla PIN:", :font_style => :bold), "#{@order.payments.last.source.pin}"]
    end
    if @order.payments.last.source.nil? && @order.payments.last.purchase_order_number.blank? && @order.payments.last.no_charge_code
      payment << [Prawn::Table::Cell.new( :text => "Payment Method:", :font_style => :bold), "No Charge"]
      payment << [Prawn::Table::Cell.new( :text => "No Charge code:", :font_style => :bold), "#{@order.payments.last.no_charge_code}"]
    end
    if @order.payments.last.source.nil? && @order.payments.last.purchase_order_number && @order.payments.last.no_charge_code.blank?
      payment << [Prawn::Table::Cell.new( :text => "Payment Method:", :font_style => :bold), "Purchase Order"]
      payment << [Prawn::Table::Cell.new( :text => "Purchase Order Number:", :font_style => :bold), "#{@order.payments.last.purchase_order_number}"]
    end
else
    payment << [Prawn::Table::Cell.new( :text => "Payment Method:", :font_style => :bold), "None"]
    payment << [Prawn::Table::Cell.new( :text => "", :font_style => :bold), ""]
end

bounding_box [bounds.right - 545, bounds.bottom + (payment.length * 18)], :width => 255 do
  table payment,
    :position => :right,
    :border_width => 0,
    :vertical_padding   => 2,
    :horizontal_padding => 6,
    :font_size => 9,
    :column_widths => { 0 => 120, 1 => 125 } ,
    :align => { 0 => :right, 1 => :left }
end

totals = []

totals << [Prawn::Table::Cell.new( :text => Spree.t(:subtotal) + ":", :font_style => :bold), number_to_currency(@order.item_total)]

@order.adjustments.eligible.each do |charge|
  totals << [Prawn::Table::Cell.new( :text => charge.label + ":", :font_style => :bold), number_to_currency(charge.amount)]
end

totals << [Prawn::Table::Cell.new( :text => Spree.t(:order_total) + ":", :font_style => :bold), number_to_currency(@order.total)]

totals << [Prawn::Table::Cell.new( :text => "Payment Total:", :font_style => :bold), number_to_currency(@order.payment_total)]

totals << [Prawn::Table::Cell.new( :text => "Balance Due:", :font_style => :bold), number_to_currency(@order.total - @order.payment_total)]

bounding_box [bounds.right - 205, bounds.bottom + (totals.length * 18)], :width => 250 do
  table totals,
    :position => :right,
    :border_width => 0,
    :vertical_padding   => 2,
    :horizontal_padding => 6,
    :font_size => 9,
    :column_widths => { 0 => 120, 1 => 75 } ,
    :align => { 0 => :right, 1 => :right }
end

