module EasyPost
  struct TrackingLocation
    include JSON::Serializable

    property object : String = "TrackingLocation"
    property city : String?
    property state : String?
    property country : String?
    property zip : String?
  end

  struct TrackingDetail
    include JSON::Serializable

    property object : String = "TrackingDetail"
    property message : String?
    property description : String?
    property status : String?
    property datetime : String?
    property carrier_code : String?
    property tracking_location : TrackingLocation?
  end

  struct TrackingCarrierDetail
    include JSON::Serializable

    property object : String = "TrackingCarrierDetail"
    property service : String?
    property container_type : String?
    property est_delivery_date_local : String?
    property est_delivery_time_local : String?
    property origin_location : String?
    property destination_location : String?
    property destination_tracking_location : TrackingLocation?
    property guaranteed_delivery_date : Time?
    property alternate_identifier : String?
    property initial_delivery_attempt : Time?
  end

  class Tracker < Resource
    include JSON::Serializable

    property id : String?
    property object : String = "Tracker"
    property mode : String?
    property created_at : Time?
    property updated_at : Time?
    property tracking_code : String?
    property status : String?
    property signed_by : String?
    property weight : Float64?
    property est_delivery_date : Time?
    property shipment_id : String?
    property tracking_details : Array(TrackingDetail)?
    property carrier : String?
    property carrier_detail : TrackingCarrierDetail?
    property public_url : String?
    property fees : Array(Fee)?
    property finalized : Bool?
    property is_return : Bool?

    def self.all(filters : NamedTuple? = nil)
      response = JSON.parse(EasyPost.make_request("GET", self.path, filters)).as_h
      {
        "trackers" => response["trackers"].as_a.map { |tracker|
          Tracker.from_json(tracker.to_json)
        },
        "has_more" => response["has_more"],
      }
    end
  end

  class CreateTrackerOptions < Resource
    property tracking_code : String?
    property carrier : String?
    property amount : String?
    property carrier_account : String?
    property is_return : Bool?
    property full_test_tracker : Bool?

    def path
      "/v2/trackers"
    end

    def create
      Tracker.from_json(
        EasyPost.make_request(
          "POST",
          self.path,
          self
        )
      )
    end
  end
end
