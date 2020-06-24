module EasyPost
  struct BatchStatus
    include JSON::Serializable

    property postage_purchased : Int32?
    property postage_purchased_failed : Int32?
    property queued_for_purchase : Int32?
    property created_failed : Int32?
  end

  class Batch < Resource
    property id : String?
    property object : String = "Shipment"
    property reference : String?
    property mode : String?
    property created_at : Time?
    property updated_at : Time?
    property state : String?
    property num_shipments : Int32?
    property shipments : Array(Shipment)?
    property status : BatchStatus?
    property label_url : String?
    property scan_form : ScanForm?
    property pickup : Pickup?

    # def buy(pickup_rate)
    #   response = JSON.parse(EasyPost.make_request("POST", "#{path}/buy", {carrier: pickup_rage.carrier, service: pickup_rate.service}))
    #   self.class.from_json(response.to_json)
    # end
  end
end
