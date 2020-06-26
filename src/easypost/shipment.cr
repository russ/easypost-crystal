module EasyPost
  struct Form
    include JSON::Serializable

    property id : String?
    property object : String = "Form"
    property mode : String?
    property form_type : String?
    property form_url : String?
    property created_at : Time?
    property updated_at : Time?
  end

  struct PostageLabel
    include JSON::Serializable

    property id : String?
    property object : String = "PostageLabel"
    property integrated_form : String?
    property label_date : Time?
    property label_epl2_url : String?
    property label_file_type : String?
    property label_pdf_url : String?
    property label_resolution : Float64?
    property label_size : String?
    property label_type : String?
    property label_url : String?
    property label_zpl_url : String?
    property created_at : Time?
    property updated_at : Time?
  end

  struct Payment
    include JSON::Serializable

    property type : String?
    property account : String?
    property postal_code : String?
  end

  struct ShipmentOptions
    include JSON::Serializable

    property additional_handling : String?
    property address_validation_level : String?
    property alcohol : Bool?
    property bill_receiver_account : String?
    property bill_receiver_postal_code : String?
    property bill_third_party_account : String?
    property bill_third_party_country : String?
    property bill_third_party_postal_code : String?
    property bill_third_party_postal_code : String?
    property by_drone : Bool?
    property carbon_neutral : Bool?
    property certified_mail : Bool?
    property cod_amount : Float64?
    property cod_method : String?
    property cod_address_id : String?
    property currency : String?
    property delivery_confirmation : String?
    property dropoff_type : String?
    property dry_ice : Bool?
    property dry_ice_medical : Bool?
    property dry_ice_weight : Float64?
    property endorsement : String?
    property freight_charge : Float64?
    property handling_instructions : String?
    property hazmat : String?
    property hold_for_pickup : Bool?
    property incoterm : String?
    property invoice_number : String?
    property label_date : Time?
    property label_format : String?
    property machinable : Bool?
    property payment : Payment?
    property print_custom_1 : String?
    property print_custom_2 : String?
    property print_custom_3 : String?
    property print_custom_1_barcode : String?
    property print_custom_2_barcode : String?
    property print_custom_3_barcode : String?
    property print_custom_1_code : String?
    property print_custom_2_code : String?
    property print_custom_3_code : String?
    property registered_mail : Bool?
    property registered_mail_amount : Float64?
    property return_receipt : Bool?
    property saturday_delivery : Bool?
    property special_rates_eligibility : String?
    property smartpost_hub : String?
    property smartpost_manifest : String?
    property billing_ref : String?
  end

  class Shipment < Resource
    include LowestRate

    property id : String?
    property object : String = "Shipment"
    property reference : String?
    property mode : String?
    property created_at : Time?
    property updated_at : Time?
    property to_address : Address?
    property from_address : Address?
    property return_address : Address?
    property buyer_address : Address?
    property parcel : Parcel?
    property carrier : String?
    property service : String?
    property carrier_accounts : Array(String)?
    property customs_info : CustomsInfo?
    property scan_form : ScanForm?
    property forms : Array(Form)?
    property insurance : String?
    property rates : Array(Rate)?
    property selected_rate : Rate?
    property postage_label : PostageLabel?
    property message : Array(CarrierMessage)?
    property options : ShipmentOptions?
    property is_return : Bool?
    property tracking_code : String?
    property usps_zone : Int32?
    property status : String?
    property tracker : Tracker?
    property fees : Array(Fee)?
    property refund_status : String?
    property batch_id : String?
    property batch_status : String?
    property batch_message : String?

    def buy(rate)
      response = JSON.parse(EasyPost.make_request("POST", "#{path}/buy", {rate: rate}))
      self.class.from_json(response.to_json)
    end

    def insure(amount)
      response = JSON.parse(EasyPost.make_request("POST", "#{path}/insure", {amount: amount}))
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
