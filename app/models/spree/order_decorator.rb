Spree::Order.class_eval do
  has_one :quote

  scope :quotes, -> {where(is_quote?: true)}

  def is_quote?
    !self.quote.nil?
  end
end