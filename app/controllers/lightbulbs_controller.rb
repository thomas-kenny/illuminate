class LightbulbsController < ApplicationController
  def index
    @lightbulbs = Lightbulb.filter(params.slice(:bulb_type, :fitting, :brightness))
  end

  def search
    # Code that scans photo for info
    resource = OcrSpace::Resource.new(apikey: "3b97b6b34b88957")
    result = resource.clean_convert url: "https://i.ibb.co/f9Vmk0F/ocr-data.png"
    bulb_type = result.scan(/(led)/i).flatten.first.to_s
    brightness = result.scan(/\d/i).join('').to_s
    fitting = result.scan(/(screw)/i).flatten.first.to_s.capitalize
    # bulb_type = "LED"
    # brightness = "470"
    # fitting = "Screw"

    @lightbulbs = Lightbulb.where({ bulb_type: bulb_type, fitting: fitting, brightness: brightness })  
  end

  def show
    @lightbulb = Lightbulb.find(params[:id])
    @lightbulbs = Lightbulb.all
    @shops = Shop.all

    # Search for similar to above but different same brand
    @similar_bulb = Lightbulb.where(bulb_type: @lightbulb[:bulb_type], fitting: @lightbulb[:fitting], brand: "B&Q") 
    #&& Lightbulb.where.not(brand: @lightbulb[:brand])

    # the `geocoded` scope filters only lightbulbs with coordinates (latitude & longitude)
    @markers = @shops.geocoded.map do |shop|
      {
        lat: shop.latitude,
        lng: shop.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { shop: shop}),
        image_url: helpers.asset_url('lightbulb_icon.png')
      }
    end
  end
end
