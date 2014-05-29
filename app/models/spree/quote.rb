class Spree::Quote < ActiveRecord::Base
  belongs_to :order

  before_create :set_expiration_date

  validate :order_items, :on => :create
  validate :order_addresses, :on => :create

  def set_expiration_date
    self.expiration_date = DateTime.now + Spree::Config[:default_expiration_period].to_i.days
  end

  def order_items
    errors_msg = []
    errors_msg = "the order must have line Items" unless order.line_items.size > 0
    errors.add :order, errors_msg unless errors_msg.empty?
  end

  def order_addresses
    errors_msg = []
    errors_msg << "Set the Shipping address before continue" if order.shipping_address.nil?
    errors_msg << "Set the Billing address before continue" if order.billing_address.nil?
    errors.add :order, errors_msg.join("<br/><br/>") unless errors_msg.empty?
  end

  def state
    expiration_date > Spree::Config[:default_expiration_period]
  end

end