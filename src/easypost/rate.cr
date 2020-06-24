module EasyPost
  class Rate < Resource
    property id : String?
    property object : String = "Rate"
    property service : String?
    property carrier : String?
    property carrier_account_id : String?
    property shipment_id : String?
    property rate : String
    property currency : String?
    property retail_rate : String?
    property retail_currency : String?
    property list_rate : String?
    property list_currency : String?
    property delivery_days : Int32?
    property delivery_date : String?
    property delivery_date_guaranteed : Bool?
    property est_delivery_days : Int32?
    property est_delivery_days : Int32?
    property created_at : Time?
    property updated_at : Time?
  end
end
