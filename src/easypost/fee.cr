module EasyPost
  struct Fee
    include JSON::Serializable

    property object : String = "Fee"
    property type : String?
    property amount : String?
    property charged : Bool?
    property refunded : Bool?
  end
end
