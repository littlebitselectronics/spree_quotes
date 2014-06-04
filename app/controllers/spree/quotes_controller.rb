module Spree
  class QuotesController < Spree::StoreController
    require 'prawn'
    respond_to :pdf

    before_action :set_bill_address, only: :create

    def show
      load_order
      render :layout => false, :template => "spree/admin/orders/quote.pdf.prawn"
    end

    def create
      @quote = Quote.find_or_create_by(quote_params)
      if @quote.valid?
        render json: @quote.to_json
      else
        flash[:error] = @quote.errors.messages.values.join(", ")
        redirect_to :back
      end
    end

    private

    def quote_params
      params[:quote].permit(:order_id, :payment_received, :bill_address_attributes)
    end

    def load_order
      @order = Quote.find(params[:id]).try(:order)
    end

    def set_bill_address
      if @order.bill_address.blank?
        if params[:quote][:user_shipping_address] == false
          @order.build_bill_address(params[:quote][:bill_address_attributes])
        else
          @order.clone_shipping_address
        end

        @order.save!
        @order.reload
      end
    end

  end
end

