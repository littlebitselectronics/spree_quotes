module Spree
  module Admin
    module QuotesHelper

      def status_text state
        state == true ? 'available' : 'expired'
      end

      def quote_payment_state payment_state
        payment_state.blank? ? 'no paid' : 'paid'
      end

    end
  end
end