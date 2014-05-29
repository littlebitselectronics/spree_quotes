require 'prawn/layout'

font "Helvetica"
im = "#{Rails.root.to_s}/app/assets/#{Spree::PrintInvoice::Config[:print_invoice_logo_path]}"

image im , :at => [0,720] #, :scale => 0.35

fill_color "E99323"
if @hide_prices
  text I18n.t(:packaging_slip), :align => :right, :style => :bold, :size => 18
else
  text I18n.t(:order_quote), :align => :right, :style => :bold, :size => 18
end
fill_color "000000"

move_down 4

font "Helvetica",  :size => 9,  :style => :bold
text "#{Spree.t(:order_number)} #{@order.number}", :align => :right
text "#{Spree.t(:expiration_date)} #{@order.quote.expiration_date.to_date}", :align => :right

render :partial => "spree/admin/orders/address"

move_down 30

render :partial => "spree/admin/orders/line_items"

move_down 8


# Footer
# render :partial => "spree/admin/orders/footer"

