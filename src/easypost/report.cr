module EasyPost
  class Report < Resource
    property id : String?
    property object : String = "Shipment"
    property reference : String?
    property mode : String?
    property created_at : Time?
    property updated_at : Time?
    property status : String?
    property include_children : Bool?
    property url : String?
    property url_expires_at : Time?
    property send_email : Bool?
    property type : String?

    @[JSON::Field(key: "start_date", converter: Time::Format.new("%F"))]
    property start_date : Time?

    @[JSON::Field(key: "end_date", converter: Time::Format.new("%F"))]
    property end_date : Time?

    def self.all(type : String)
      response = JSON.parse(EasyPost.make_request("GET", "#{self.path}/#{type}"))
      {
        "reports" => response["reports"].as_a.map { |report|
          Report.from_json(report.to_json)
        },
        "has_more" => response["has_more"],
      }
    end

    def create
      self.class.from_json(
        EasyPost.make_request(
          "POST",
          "#{self.class.path}/#{type}",
          {self.class.resource_name => self}
        )
      )
    end
  end
end
