class AddPaymentReceivedFieldToQuoteTable < ActiveRecord::Migration
  def change
    add_column :spree_quotes, :payment_received, :boolean, default: false
  end
end
