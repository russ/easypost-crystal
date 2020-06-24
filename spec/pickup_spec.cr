require "./spec_helper"

describe EasyPost::Pickup do
  describe "#create" do
    it "creates a pickup and returns rates" do
      EightTrack.use_tape("creates-a-pickup-and-returns-rates") do
        shipment = EasyPost::Shipment.from_json(
          {
            to_address:   EasyPost::Address.from_json(ADDRESS[:california].to_json).create,
            from_address: EasyPost::Address.from_json(ADDRESS[:missouri].to_json).create,
            parcel:       EasyPost::Parcel.from_json(PARCEL[:dimensions].to_json).create,
          }.to_json
        ).create

        purchased_shipment = shipment.buy(shipment.lowest_rate(carriers: ["UPS"], services: ["NextDayAirEarlyAM"]))

        pickup = EasyPost::Pickup.from_json({
          address:            shipment.from_address.not_nil!,
          reference:          "12345678",
          min_datetime:       1.day.from_now,
          max_datetime:       1.day.from_now,
          is_account_address: false,
          instructions:       "At the front door.",
          shipment:           purchased_shipment,
        }.to_json).create

        pickup.class.should eq(EasyPost::Pickup)
        pickup.pickup_rates.not_nil!.first.class.should eq(EasyPost::PickupRate)
      end
    end

    it "fails-to-create-a-pickup" do
      EightTrack.use_tape("fails-to-create-a-pickup") do
        shipment = EasyPost::Shipment.from_json(
          {
            to_address:   EasyPost::Address.from_json(ADDRESS[:california].to_json).create,
            from_address: EasyPost::Address.from_json(ADDRESS[:missouri].to_json).create,
            parcel:       EasyPost::Parcel.from_json(PARCEL[:dimensions].to_json).create,
          }.to_json
        ).create

        purchased_shipment = shipment.buy(shipment.lowest_rate(carriers: ["UPS"], services: ["NextDayAirEarlyAM"]))

        expect_raises(EasyPost::Error, /Invalid request, 'min_datetime' is required./) do
          EasyPost::Pickup.from_json({
            address:            shipment.from_address.not_nil!,
            reference:          "12345678",
            max_datetime:       1.day.from_now,
            is_account_address: false,
            instructions:       "At the front door.",
            shipment:           purchased_shipment,
          }.to_json).create
        end
      end
    end
  end

  describe "#buy" do
    it "buys a pickup rate" do
      EightTrack.use_tape("buys-a-pickup-rate") do
        shipment = EasyPost::Shipment.from_json(
          {
            to_address:   EasyPost::Address.from_json(ADDRESS[:california].to_json).create,
            from_address: EasyPost::Address.from_json(ADDRESS[:missouri].to_json).create,
            parcel:       EasyPost::Parcel.from_json(PARCEL[:dimensions].to_json).create,
          }.to_json
        ).create

        purchased_shipment = shipment.buy(shipment.lowest_rate(carriers: ["UPS"], services: ["NextDayAirEarlyAM"]))

        pickup = EasyPost::Pickup.from_json({
          address:            shipment.to_address.not_nil!,
          reference:          "buy12345678",
          min_datetime:       1.day.from_now,
          max_datetime:       1.day.from_now,
          is_account_address: false,
          instructions:       "At the front door.",
          shipment:           purchased_shipment,
        }.to_json).create

        purchased_pickup = pickup.buy(pickup.pickup_rates.not_nil!.first)

        purchased_pickup.confirmation.should_not be_nil
      end
    end
  end

  describe "#cancel" do
    it "cancels a pickup" do
      EightTrack.use_tape("cancels-a-pickup") do
        shipment = EasyPost::Shipment.from_json(
          {
            to_address:   EasyPost::Address.from_json(ADDRESS[:california].to_json).create,
            from_address: EasyPost::Address.from_json(ADDRESS[:missouri].to_json).create,
            parcel:       EasyPost::Parcel.from_json(PARCEL[:dimensions].to_json).create,
          }.to_json
        ).create

        purchased_shipment = shipment.buy(shipment.lowest_rate(carriers: ["UPS"], services: ["NextDayAirEarlyAM"]))

        pickup = EasyPost::Pickup.from_json({
          address:            shipment.to_address.not_nil!,
          reference:          "buy12345678",
          min_datetime:       1.day.from_now,
          max_datetime:       1.day.from_now,
          is_account_address: false,
          instructions:       "At the front door.",
          shipment:           purchased_shipment,
        }.to_json).create

        purchased_pickup = pickup.buy(pickup.pickup_rates.not_nil!.first)

        purchased_pickup.status.should eq("scheduled")

        canceled_pickup = purchased_pickup.cancel

        canceled_pickup.status.should eq("canceled")
      end
    end
  end
end
