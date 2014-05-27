module Spree
  module Admin
    class QuotesController < BaseController
      respond_to :pdf

      def index
        @quotes = Quote.all
      end

      def show
        load_order
        render :layout => false , :template => "spree/admin/orders/quote.pdf.prawn"
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

      def load_order
        @order = Quote.find(params[:id]).try(:order)
        authorize! action, @order
      end

    end
  end
end

