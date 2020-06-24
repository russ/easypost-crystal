module EasyPost
  class ScanForm < Resource
    property id : String?
    property object : String = "SanForm"
    property created_at : Time?
    property updated_at : Time?
    property status : String?
    property message : String?
    property address : Address?
    property tracking_codes : Array(String)?
    property form_url : String?
    property form_file_type : String?
    property batch_id : String?

    def self.all(filters : NamedTuple)
      response = JSON.parse(EasyPost.make_request("GET", self.path, filters)).as_h
      {
        "scan_forms" => response["scan_forms"].as_a.map { |scan_form|
          ScanForm.from_json(scan_form.to_json)
        },
        "has_more" => response["has_more"],
      }
    end
  end

  class ScanFormRequest < Resource
    property shipments : Array(Shipment)?

    def self.path
      "/v2/scan_forms"
    end

    def self.create(shipments : Array(Shipment))
      ScanForm.from_json(
        EasyPost.make_request(
          "POST",
          self.path,
          {"shipments" => shipments}
        )
      )
    end
  end
end
