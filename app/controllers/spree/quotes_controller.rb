module Spree
  class QuotesController < Spree::StoreController
    respond_to :pdf

    before_action :set_bill_address, only: :create

    def show
      load_order
      render :layout => false, :template => "spree/admin/orders/quote.pdf.prawn"
    end

    def create
      @quote = Quote.find_by(quote_params) || Quote.create(quote_params)
      if @quote.valid? && @order.bill_address.present?
        render json: @quote.to_json, status: 200
      else
        @quote.errors.add(:bill_address, Spree.t('errors.bill_address')) if @order.bill_address.nil?
        render json: @quote.errors.messages.values.join(", "), status: 422
      end
    end

    private

    def quote_params
      params[:quote].permit(:order_id, :payment_received)
    end

    def address_params
      params[:quote].permit(
        :use_shipping_address,
        :bill_address_attributes => permitted_address_attributes)
    end

    def load_order
      @order = Quote.find(params[:id]).try(:order)
    end

    def set_bill_address
      @order.bill_address = spree_current_user.default_bill_address
      if @order.bill_address.blank?
        if address_params[:use_shipping_address] == 'false'
          @order.build_bill_address(address_params[:bill_address_attributes])
        else
          @order.clone_shipping_address
        end
      end

      @order.save
      @order.reload
    end

  end
end

