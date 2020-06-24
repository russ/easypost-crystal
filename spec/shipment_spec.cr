require "./spec_helper"

describe EasyPost::Shipment do
  describe "#create" do
    it "creates a shipment object" do
      EightTrack.use_tape("creates-a-shipment-object") do
        shipment = EasyPost::Shipment.from_json(
          {
            to_address:   EasyPost::Address.from_json(ADDRESS[:california].to_json).create,
            from_address: EasyPost::Address.from_json(ADDRESS[:missouri].to_json).create,
            parcel:       EasyPost::Parcel.from_json(PARCEL[:dimensions].to_json).create,
          }.to_json
        ).create

        shipment.class.should eq(EasyPost::Shipment)
        shipment.from_address.class.should eq(EasyPost::Address)
      end
    end

    it "creates a shipment object when options has contains id" do
      EightTrack.use_tape("creates-a-shipment-object-when-options-hash-contains-id") do
        shipment = EasyPost::Shipment.from_json(
          {
            to_address:   EasyPost::Address.from_json(ADDRESS[:california].to_json),
            from_address: EasyPost::Address.from_json(ADDRESS[:missouri].to_json).create,
            parcel:       EasyPost::Parcel.from_json(PARCEL[:dimensions].to_json).create,
            options:      EasyPost::ShipmentOptions.from_json(OPTIONS[:mws].to_json),
          }.to_json
        ).create

        shipment.class.should eq(EasyPost::Shipment)
        shipment.from_address.class.should eq(EasyPost::Address)
      end
    end
  end

  describe "#buy" do
    it "purchases postage for an international shipment" do
      EightTrack.use_tape("buy-purchases-postage-for-an-international-shipment") do
        shipment = EasyPost::Shipment.from_json(
          {
            to_address:   EasyPost::Address.from_json(ADDRESS[:canada].to_json).create,
            from_address: EasyPost::Address.from_json(ADDRESS[:california].to_json).create,
            parcel:       EasyPost::Parcel.from_json(PARCEL[:dimensions].to_json).create,
            customs_info: EasyPost::CustomsInfo.from_json(CUSTOMS_INFO[:shirt].to_json).create,
          }.to_json
        ).create

        shipment.class.should eq(EasyPost::Shipment)
        purchased_shipment = shipment.buy(shipment.lowest_rate(carriers: ["usps"]))

        purchased_shipment.postage_label.not_nil!.label_url.not_nil!.size.should be > 0
      end
    end

    it "purchases postage for a domestic shipment" do
      EightTrack.use_tape("buy-purchases-postage-for-a-domestic-shipment") do
        shipment = EasyPost::Shipment.from_json(
          {
            to_address:   EasyPost::Address.from_json(ADDRESS[:missouri].to_json).create,
            from_address: EasyPost::Address.from_json(ADDRESS[:california].to_json).create,
            parcel:       EasyPost::Parcel.from_json(PARCEL[:dimensions].to_json).create,
          }.to_json
        ).create

        shipment.class.should eq(EasyPost::Shipment)
        purchased_shipment = shipment.buy(shipment.lowest_rate(["usps"]))

        purchased_shipment.postage_label.not_nil!.label_url.not_nil!.size.should be > 0
      end
    end

    it "creates and returns a tracker with shipment purchase" do
      EightTrack.use_tape("creates-and-returns-a-tracker-with-shipment-purchase") do
        shipment = EasyPost::Shipment.from_json(
          {
            to_address:   EasyPost::Address.from_json(ADDRESS[:missouri].to_json).create,
            from_address: EasyPost::Address.from_json(ADDRESS[:california].to_json).create,
            parcel:       EasyPost::Parcel.from_json(PARCEL[:dimensions].to_json).create,
          }.to_json
        ).create

        purchased_shipment = shipment.buy(shipment.lowest_rate(["usps"]))
        purchased_shipment.tracker.not_nil!.shipment_id.should eq(purchased_shipment.id)
      end
    end

    it "purchases postage when only a rate id is provided" do
      EightTrack.use_tape("purchases-postage-when-only-a-rate-id-is-provided") do
        shipment = EasyPost::Shipment.from_json(
          {
            to_address:   EasyPost::Address.from_json(ADDRESS[:missouri].to_json).create,
            from_address: EasyPost::Address.from_json(ADDRESS[:california].to_json).create,
            parcel:       EasyPost::Parcel.from_json(PARCEL[:dimensions].to_json).create,
          }.to_json
        ).create

        shipment.class.should eq(EasyPost::Shipment)

        purchased_shipment = shipment.buy(shipment.lowest_rate(["usps"]))

        purchased_shipment.postage_label.not_nil!.label_url.not_nil!.size.should be > 0
        purchased_shipment.tracker.not_nil!.shipment_id.should eq(purchased_shipment.id)
      end
    end
  end

  describe "#insure" do
    it "buys and insures a shipment" do
      EightTrack.use_tape("buys-and-insures-a-shipment") do
        shipment = EasyPost::Shipment.from_json(
          {
            to_address:   EasyPost::Address.from_json(ADDRESS[:missouri].to_json).create,
            from_address: EasyPost::Address.from_json(ADDRESS[:california].to_json).create,
            parcel:       EasyPost::Parcel.from_json(PARCEL[:dimensions].to_json).create,
          }.to_json
        ).create

        shipment.class.should eq(EasyPost::Shipment)

        purchased_shipment = shipment.buy(shipment.lowest_rate(["usps"]))
        insured_shipment = purchased_shipment.insure(100)

        insured_shipment.insurance.should eq("100.00")
      end
    end
  end

  describe "#lowest_rate" do
    describe "domestic shipment" do
      it "filters negative services" do
        EightTrack.use_tape("lowest-rate-domestic-shipment-filters-negative-services") do
          shipment = EasyPost::Shipment.from_json(
            {
              to_address:   EasyPost::Address.from_json(ADDRESS[:missouri].to_json).create,
              from_address: EasyPost::Address.from_json(ADDRESS[:california].to_json).create,
              parcel:       EasyPost::Parcel.from_json(PARCEL[:dimensions].to_json).create,
            }.to_json
          ).create

          rate = shipment.lowest_rate(carriers: ["usps"], services: ["!MediaMail", "!LibraryMail"])
          rate.service.should eq("ParcelSelect")
        end
      end
    end
  end

  describe "#retreive" do
    it "retrieves shipment by id" do
      EightTrack.use_tape("retreives-shipment-by-id") do
        shipment = EasyPost::Shipment.from_json(
          {
            to_address:   EasyPost::Address.from_json(ADDRESS[:missouri].to_json).create,
            from_address: EasyPost::Address.from_json(ADDRESS[:california].to_json).create,
            parcel:       EasyPost::Parcel.from_json(PARCEL[:dimensions].to_json).create,
          }.to_json
        ).create

        found_shipment = EasyPost::Shipment.retrieve(shipment.id)
        found_shipment.id.should eq(shipment.id)
      end
    end
  end
end
