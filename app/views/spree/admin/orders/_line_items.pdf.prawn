if @hide_prices
  @column_widths = { 0 => 100, 1 => 165, 2 => 75, 3 => 75 }
  @align = { 0 => :left, 1 => :left, 2 => :right, 3 => :right }
else
  @column_widths = { 0 => 120, 1 => 235, 2 => 50, 3 => 50, 4 => 85 }
  @align = { 0 => :left, 1 => :left, 2 => :right, 3 => :right, 4 => :right}
end

# Line Items
bounding_box [0,cursor], :width => 540, :height => 430 do
  move_down 0
  header =  [Prawn::Table::Cell.new( :text => Spree.t(:sku), :font_style => :bold),
                Prawn::Table::Cell.new( :text => Spree.t(:item_description), :font_style => :bold ) ]
  header <<  Prawn::Table::Cell.new( :text => Spree.t(:price), :font_style => :bold ) unless @hide_prices
  header <<  Prawn::Table::Cell.new( :text => Spree.t(:qty), :font_style => :bold, :align => 1 )
  header <<  Prawn::Table::Cell.new( :text => Spree.t(:total), :font_style => :bold ) unless @hide_prices

  table [header],
    :position           => :center,
    :border_width => 1,
    :vertical_padding   => 2,
    :horizontal_padding => 6,
    :font_size => 9,
    :column_widths => @column_widths ,
    :align => @align

  move_down 0

  bounding_box [0,cursor], :width => 540 do
    move_down 2
    content = []
    @order.line_items.each do |item|
      row = [ item.variant.product.sku, item.variant.product.name]
      row << number_to_currency(item.price) unless @hide_prices
      row << item.quantity
      row << number_to_currency(item.price * item.quantity) unless @hide_prices
      content << row
    end


    table content,
      :position           => :center,
      :border_width => 0.5,
      :vertical_padding   => 5,
      :horizontal_padding => 6,
      :font_size => 9,
      :column_widths => @column_widths ,
      :align => @align
  end

  font "Helvetica", :size => 9

  render :partial => "spree/admin/orders/quote_totals" unless @hide_prices

  move_down 2

  stroke do
    line_width 0.5
    line bounds.top_left, bounds.top_right
    line bounds.top_left, bounds.bottom_left
    line bounds.top_right, bounds.bottom_right
    line bounds.bottom_left, bounds.bottom_right
  end

end

