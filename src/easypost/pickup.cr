module EasyPost
  struct PickupRate
    include JSON::Serializable

    property id : String?
    property object : String = "Shipment"
    property reference : String?
    property mode : String?
    property created_at : Time?
    property updated_at : Time?
    property service : String?
    property carrier : String?
    property rate : String?
    property currency : String?
    property pickup_id : String?
  end

  class Pickup < Resource
    property id : String?
    property object : String = "Shipment"
    property reference : String?
    property mode : String?
    property created_at : Time?
    property updated_at : Time?
    property status : String?
    property min_datetime : Time?
    property max_datetime : Time?
    property is_account_address : Bool?
    property instructions : String?
    property messages : Array(String)?
    property confirmation : String?
    property shipment : Shipment?
    property address : Address?
    property batch : Batch?
    property carrier_accounts : Array(CarrierAccount)?
    property pickup_rates : Array(PickupRate)?

    def buy(pickup_rate)
      response = JSON.parse(EasyPost.make_request("POST", "#{path}/buy", {carrier: pickup_rate.carrier, service: pickup_rate.service}))
      self.class.from_json(response.to_json)
    end

    def cancel
      response = JSON.parse(EasyPost.make_request("POST", "#{path}/cancel"))
      self.class.from_json(response.to_json)
    end
  end
end
