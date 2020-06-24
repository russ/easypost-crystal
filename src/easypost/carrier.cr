module EasyPost
  struct CarrierField
    include JSON::Serializable

    property visibility : String?
    property label : String?
    property value : String?
  end

  struct CarrierFields
    include JSON::Serializable

    property credentials : Array(CarrierField)?
    property test_credentials : Array(CarrierField)?
    property auto_link : Bool?
    property custom_workflow : Bool?
  end

  struct CarrierAccount
    include JSON::Serializable

    property id : String?
    property object : String = "CarrierAccount"
    property created_at : Time?
    property updated_at : Time?
    property type : String?
    property fields : CarrierFields?
    property clone : Bool?
    property description : String?
    property readable : String?
    property credentials : Array(String)?
    property test_credentials : Array(String)?
  end

  struct CarrierType
    include JSON::Serializable

    property object : String = "CarrierType"
    property type : String?
    property fields : CarrierFields?
  end
end
