require "./spec_helper"

describe EasyPost::Insurance do
  describe "#create" do
    it "creates an insurance object" do
      EightTrack.use_tape("creates-an-insurance-object") do
        insurance = EasyPost::Insurance.from_json(
          {
            to_address:    EasyPost::Address.from_json(ADDRESS[:california].to_json).create,
            from_address:  EasyPost::Address.from_json(ADDRESS[:missouri].to_json).create,
            amount:        "101.0",
            tracking_code: "EZ2000000002",
            carrier:       "usps",
          }.to_json
        ).create

        insurance.class.should eq(EasyPost::Insurance)
        insurance.id.should_not eq(nil)
        insurance.amount.should eq("101.00000")
      end
    end
  end

  describe "#retrieve" do
    it "retreives an insurance object" do
      EightTrack.use_tape("retreives-an-insurance-object") do
        insurance = EasyPost::Insurance.from_json(
          {
            to_address:    EasyPost::Address.from_json(ADDRESS[:california].to_json).create,
            from_address:  EasyPost::Address.from_json(ADDRESS[:missouri].to_json).create,
            amount:        "101.0",
            tracking_code: "EZ2000000002",
            carrier:       "usps",
          }.to_json
        ).create

        found_insurance = EasyPost::Insurance.retrieve(insurance.id)

        found_insurance.class.should eq(EasyPost::Insurance)
        found_insurance.id.should eq(insurance.id)
        found_insurance.amount.should eq("101.00000")
        found_insurance.tracking_code.should eq("EZ2000000002")
        found_insurance.tracker.not_nil!.class.should eq(EasyPost::Tracker)
      end
    end
  end

  describe "#index" do
    it "retreives a full page of insurances" do
      EightTrack.use_tape("retreives-a-full-page-of-insurances") do
        insurances = EasyPost::Insurance.all({page_size: 5})
        insurances["insurances"].size.should eq(5)
        insurances["has_more"].should eq(true)
      end
    end

    it "retrieves all insurances with given tracking code, up to a page" do
      EightTrack.use_tape("retreives-all-insurances-with-given-tracking-code-up-to-a-page") do
        insurances = EasyPost::Insurance.all({tracking_code: "EZ2000000002", page_size: 5})
        insurances["insurances"].size.should eq(5)
        insurances["has_more"].should eq(true)
      end
    end

    it "retrieves all insurances with given tracking code and carrier, up to a page" do
      EightTrack.use_tape("retreives-all-insurances-with-given-tracking-code-and-carrier-up-to-a-page") do
        insurances = EasyPost::Insurance.all({tracking_code: "EZ2000000002", carrier: "usps", page_size: 5})
        insurances["insurances"].size.should eq(5)
        insurances["has_more"].should eq(true)
      end
    end
  end
end
