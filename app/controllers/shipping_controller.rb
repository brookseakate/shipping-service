require 'timeout'

class ShippingController < ApplicationController
  def search
    logger.info(">>>>>>>>>>> REQUEST PARAMS: #{ params }")

    shipment_hash = {
      weight: params[:weight].to_f,
      origin_country: params[:origin_country],
      origin_state: params[:origin_state],
      origin_city: params[:origin_city],
      origin_zip: params[:origin_zip],
      destination_country: params[:destination_country],
      destination_state: params[:destination_state],
      destination_city: params[:destination_city],
      destination_zip: params[:destination_zip]
    }
    
    Timeout::timeout(5) do
      begin
        results = ShippingRate.get_rates(shipment_hash)
      rescue ActiveShipping::ResponseError => err
        render json: { "error": err.response.message } and return
      end

      render json: results, except: [:created_at, :updated_at]

      logger.info(">>>>>>>>>>> RENDERED: #{ results.to_json }")
    end
  end
end
