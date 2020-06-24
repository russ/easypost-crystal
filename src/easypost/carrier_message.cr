module EasyPost
  struct CarrierMessage
    include JSON::Serializable

    property carrier : String
    property type : String
    property message : String?
    property carrier_account_id : String
  end
end
