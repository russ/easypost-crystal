module EasyPost
  class Insurance < Resource
    property id : String?
    property object : String?
    property reference : String?
    property mode : String?
    property created_at : Time?
    property updated_at : Time?
    property amount : String?
    property carrier : String?
    property provider : String?
    property provider_id : String?
    property shipment_id : String?
    property tracking_code : String?
    property status : String?
    property tracker : Tracker?
    property to_address : Address?
    property from_address : Address?
    property fee : Fee?
    property messages : Array(String)?

    def self.all(filters : NamedTuple)
      response = JSON.parse(EasyPost.make_request("GET", self.path, filters)).as_h
      {
        "insurances" => response["insurances"].as_a.map { |insurance|
          Insurance.from_json(insurance.to_json)
        },
        "has_more" => response["has_more"],
      }
    end
  end
end
