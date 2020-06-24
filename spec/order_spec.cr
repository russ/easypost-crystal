require "./spec_helper"

describe EasyPost::Order do
  describe "#create" do
    it "creates an order out of a single shipment" do
      EightTrack.use_tape("creates-an-order-out-of-a-single-shipment") do
        to_address = EasyPost::Address.from_json(ADDRESS[:california].to_json).create
        from_address = EasyPost::Address.from_json(ADDRESS[:missouri].to_json).create
        parcel = EasyPost::Parcel.from_json(PARCEL[:dimensions].to_json).create

        order = EasyPost::Order.from_json(
          {
            to_address:   to_address,
            from_address: from_address,
            shipments:    [{
              to_address:   to_address,
              from_address: from_address,
              parcel:       parcel,
            }],
          }.to_json
        ).create

        order.class.should eq(EasyPost::Order)
        order.shipments.not_nil!.first.class.should eq(EasyPost::Shipment)
      end
    end

    it "creates an order out of two shipments" do
      EightTrack.use_tape("creates-an-order-out-of-two-shipments") do
        to_address = EasyPost::Address.from_json(ADDRESS[:california].to_json).create
        from_address = EasyPost::Address.from_json(ADDRESS[:missouri].to_json).create
        parcel = EasyPost::Parcel.from_json(PARCEL[:dimensions].to_json).create

        order = EasyPost::Order.from_json(
          {
            to_address:   to_address,
            from_address: from_address,
            shipments:    [
              {
                to_address:   to_address,
                from_address: from_address,
                parcel:       parcel,
              },
              {
                to_address:   to_address,
                from_address: from_address,
                parcel:       parcel,
              },
            ],
          }.to_json
        ).create

        order.class.should eq(EasyPost::Order)
        order.shipments.not_nil!.size.should eq(2)
        order.shipments.not_nil!.first.class.should eq(EasyPost::Shipment)
      end
    end
  end
end
