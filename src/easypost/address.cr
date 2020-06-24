module EasyPost
  struct AddressVerificationFieldError
    include JSON::Serializable

    property code : String
    property field : String
    property message : String
    property suggestion : String?
  end

  struct AddressVerificationDetails
    include JSON::Serializable

    property latitude : String
    property longitude : String
    property time_zone : String
  end

  struct AddressVerification
    include JSON::Serializable

    property success : Bool
    property errors : Array(AddressVerificationFieldError)
    property details : AddressVerificationDetails
  end

  struct AddressVerifications
    include JSON::Serializable

    property zip4 : AddressVerification
    property delivery : AddressVerification
  end

  class Address < Resource
    property id : String?
    property object : String?
    property reference : String?
    property mode : String?
    property street1 : String?
    property street2 : String?
    property city : String?
    property state : String?
    property zip : String?
    property country : String?
    property verify : String?
    property verify_strict : String?
    property residential : Bool?
    property carrier_facility : String?
    property name : String?
    property company : String?
    property phone : String?
    property email : String?
    property federal_tax_id : String?
    property state_tax_id : String?

    def self.create_and_verify(params)
      self.from_json(params.to_json).create.verify
    end

    def verify(carrier = nil)
      response = JSON.parse(EasyPost.make_request("GET", "#{path}/verify?carrier=#{carrier}", self))
      if response["address"]?
        self.class.from_json(response["address"].to_json)
      else
        raise Error.new("Unable to verify address.")
      end
    end
  end
end
