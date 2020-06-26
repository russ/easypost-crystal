module EasyPost
  class Order < Resource
    include LowestRate

    property id : String?
    property object : String?
    property reference : String?
    property mode : String?
    property created_at : Time?
    property updated_at : Time?
    property to_address : Address?
    property from_address : Address?
    property return_address : Address?
    property buyer_address : Address?
    property shipments : Array(Shipment)?
    property rates : Array(Rate)?
    property messages : Array(CarrierMessage)?
    property is_return : Bool?

    def buy(rate)
      response = JSON.parse(EasyPost.make_request("POST", "#{path}/buy", {rate: rate}))
      self.class.from_json(response.to_json)
    end

    private def get_rates
      response = JSON.parse(EasyPost.make_request("GET", "#{path}/rates"))
      self.rates = JSON.parse(response.to_json)["rates"].as_a.map do |r|
        Rate.from_json(r.to_json)
      end
    end
  end
end
