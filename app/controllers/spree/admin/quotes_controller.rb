module Spree
  module Admin
    class QuotesController < BaseController
      before_action :load_quote, only: [:edit, :update]
      respond_to :pdf

      def index
        @quotes = Quote.all
      end

      def show
        load_order
        render :layout => false , :template => "spree/admin/orders/quote.pdf.prawn"
      end

      def create
        @quote = Quote.find_or_create_by(quote_params)
        if @quote.valid?
          flash[:success] = Spree.t('quote_created')
          redirect_to edit_admin_quote_path(@quote)
        else
          flash[:error] = @quote.errors.messages.values.join(", ")
          redirect_to :back
        end
      end

      def edit; end

      def update
        if @quote.update_attributes(quote_params)
          flash[:success] = Spree.t('quote_updated')
          redirect_to edit_admin_quote_path(@quote)
        else
          flash[:error] = @quote.errors.messages.values.join(", ")
          render :action => :edit
        end
      end

      private

      def quote_params
        params[:quote].permit(:order_id, :payment_received)
      end

      def load_order
        @order = Quote.find(params[:id]).try(:order)
        authorize! action, @order
      end

      def load_quote
        @quote = Quote.find(params[:id])
      end

    end
  end
end

