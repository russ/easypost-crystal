require "./spec_helper"

describe EasyPost::ScanForm do
  describe "#create" do
    it "purchases postage for an international shipment" do
      EightTrack.use_tape("purchases-postage-for-an-international-shipment") do
        shipment = EasyPost::Shipment.from_json(
          {
            to_address:   EasyPost::Address.from_json(ADDRESS[:canada].to_json).create,
            from_address: EasyPost::Address.from_json(ADDRESS[:california].to_json).create,
            parcel:       EasyPost::Parcel.from_json(PARCEL[:dimensions].to_json).create,
            customs_info: EasyPost::CustomsInfo.from_json(CUSTOMS_INFO[:shirt].to_json).create,
          }.to_json
        ).create

        purchased_shipment = shipment.buy(shipment.lowest_rate(carriers: ["usps"]))

        scan_form = EasyPost::ScanFormRequest.create([purchased_shipment])

        scan_form.id.should_not be_nil
        scan_form.tracking_codes.not_nil!.first.should eq(purchased_shipment.tracking_code)
      end
    end
  end

  describe "#retrieve" do
    it "retrieves the same scan_form" do
      EightTrack.use_tape("retrieves-the-same-scan_form") do
        shipment = EasyPost::Shipment.from_json(
          {
            to_address:   EasyPost::Address.from_json(ADDRESS[:canada].to_json).create,
            from_address: EasyPost::Address.from_json(ADDRESS[:california].to_json).create,
            parcel:       EasyPost::Parcel.from_json(PARCEL[:dimensions].to_json).create,
            customs_info: EasyPost::CustomsInfo.from_json(CUSTOMS_INFO[:shirt].to_json).create,
          }.to_json
        ).create

        purchased_shipment = shipment.buy(shipment.lowest_rate(carriers: ["usps"]))
        scan_form = EasyPost::ScanFormRequest.create([purchased_shipment])

        found_scan_form = EasyPost::ScanForm.retrieve(scan_form.id)
        found_scan_form.id.should eq(scan_form.id)
      end
    end
  end

  describe "#all" do
    it "indexes the scan forms" do
      EightTrack.use_tape("indexes-the-scan-form") do
        shipment = EasyPost::Shipment.from_json(
          {
            to_address:   EasyPost::Address.from_json(ADDRESS[:canada].to_json).create,
            from_address: EasyPost::Address.from_json(ADDRESS[:california].to_json).create,
            parcel:       EasyPost::Parcel.from_json(PARCEL[:dimensions].to_json).create,
            customs_info: EasyPost::CustomsInfo.from_json(CUSTOMS_INFO[:shirt].to_json).create,
          }.to_json
        ).create

        purchased_shipment = shipment.buy(shipment.lowest_rate(carriers: ["usps"]))
        scan_form = EasyPost::ScanFormRequest.create([purchased_shipment])

        scan_forms = EasyPost::ScanForm.all({page_size: 2})
        scan_forms["scan_forms"].as(Array(EasyPost::ScanForm)).first.id.should eq(scan_form.id)
      end
    end
  end
end
