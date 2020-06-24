module EasyPost
  class CustomsInfo < Resource
    include JSON::Serializable

    property id : String?
    property object : String = "Form"
    property created_at : Time?
    property updated_at : Time?
    property eel_pfc : String?
    property contents_type : String?
    property contents_explanation : String?
    property customs_certify : Bool?
    property customs_signer : String?
    property non_delivery_option : String?
    property restriction_type : String?
    property customs_items : Array(CustomsItem)?
  end

  struct CustomsItem
    include JSON::Serializable

    property id : String?
    property object : String = "CustomsItem"
    property created_at : Time?
    property updated_at : Time?
    property description : String?
    property quantity : Float32?
    property value : String?
    property weight : Float32?
    property hs_tariff_number : String?
    property code : String?
    property origin_country : String?
    property currency : String?
  end

  struct CustomsInfoRequest
    include JSON::Serializable

    property customs_info : CustomsInfo?
  end
end
