class Spree::Quote < ActiveRecord::Base
  belongs_to :order
end