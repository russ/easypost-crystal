module EasyPost
  class Parcel < Resource
    property id : String?
    property object : String = "Parcel"
    property mode : String?
    property length : Float64
    property width : Float64
    property height : Float64
    property weight : Float64
    property predefined_package : String?
    property created_at : Time?
    property updated_at : Time?
  end
end
