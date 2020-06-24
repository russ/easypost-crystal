require "./spec_helper"

describe EasyPost::Address do
  describe "#create" do
    it "creates an address object" do
      EightTrack.use_tape("creates-an-address-object") do
        address = EasyPost::Address.from_json(ADDRESS[:california].to_json).create
        address.class.should eq(EasyPost::Address)
        address.company.should eq("EasyPost")
      end
    end
  end

  describe "#verify" do
    it "verifies an address with an error" do
      EightTrack.use_tape("verify-is-not-able-to-verify-address") do
        address = EasyPost::Address.from_json(ADDRESS[:california].to_json)
        address.street1, address.company = nil, nil
        address = address.create

        address.street1.should eq(nil)
        address.street2.should eq("Unit 1")
        address.city.should eq("San Francisco")
        address.state.should eq("CA")
        address.zip.should eq("94107")
        address.country.should eq("US")

        expect_raises(EasyPost::Error, /Unable to verify address/) do
          address.verify
        end
      end
    end

    it "verifies an address without message" do
      EightTrack.use_tape("verify-verifies-and-address-without-message") do
        address = EasyPost::Address.from_json(ADDRESS[:california].to_json).create
        verified_address = address.verify
        verified_address.class.should eq(EasyPost::Address)
      end
    end

    it "verifies an address using a carrier" do
      EightTrack.use_tape("verify-verifies-an-address-using-a-carrier") do
        address = EasyPost::Address.from_json(ADDRESS[:california].to_json).create

        address.company.should eq("EasyPost")
        address.street1.should eq("164 Townsend Street")
        address.city.should eq("San Francisco")
        address.state.should eq("CA")
        address.zip.should eq("94107")
        address.country.should eq("US")

        verified_address = address.verify("usps")
        verified_address.class.should eq(EasyPost::Address)
      end
    end

    it "is not able to verify address" do
      EightTrack.use_tape("verify-is-not-able-to-verify-address") do
        address = EasyPost::Address.from_json({
          company: "Simpler Postage Inc",
          street1: "388 Junk Teerts",
          street2: "Apt 20",
          city:    "San Francisco",
          state:   "CA",
          zip:     "941abc07",
        }.to_json).create

        expect_raises(EasyPost::Error, /Unable to verify address/) do
          address.verify
        end
      end
    end
  end
end
