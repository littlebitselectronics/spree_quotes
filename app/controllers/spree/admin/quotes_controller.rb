module Spree
  module Admin
    class QuotesController < BaseController

      def index
        @quotes = Quote.all
      end

      def create
        @quote = Quote.new quote_params
        if @quote.save
          redirect_to admin_quotes_path
        else
          redirect_to :back
        end

      end

      private
        def quote_params
          params[:quote].permit(:order_id)
        end
    end
  end
end

