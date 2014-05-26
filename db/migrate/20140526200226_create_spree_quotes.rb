class CreateSpreeQuotes < ActiveRecord::Migration
  def change
    create_table :spree_quotes do |t|
      t.datetime :expiration_date
      t.integer :spree_order_id
    end
  end
end
