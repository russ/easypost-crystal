require "./spec_helper"

describe EasyPost::Report do
  describe "#create" do
    it "creates a report object" do
      EightTrack.use_tape("creates-a-report-object") do
        report = EasyPost::Report.from_json({
          start_date: 30.days.ago,
          end_date:   Time.utc,
          type:       "shipment",
        }.to_json).create

        report.object.should eq("ShipmentReport")
        ["available", "new"].includes?(report.status).should eq(true)
      end
    end
  end

  describe "#retrieve" do
    it "retrieves a user created report by public_id as a hash" do
      EightTrack.use_tape("retrieves-a-user-created-report-by-public_id-as-a-hash") do
        report = EasyPost::Report.from_json({
          start_date: 30.days.ago,
          end_date:   Time.utc,
          type:       "shipment",
        }.to_json).create

        found_report = EasyPost::Report.retrieve(report.id)

        report.id.should eq(found_report.id)
      end
    end

    it "retrieves all user created reports" do
      EightTrack.use_tape("retrieves-all-user-created-reports") do
        report_1 = EasyPost::Report.from_json({
          start_date: 25.days.ago,
          end_date:   Time.utc,
          type:       "shipment",
        }.to_json).create

        report_2 = EasyPost::Report.from_json({
          start_date: 29.days.ago,
          end_date:   Time.utc,
          type:       "shipment",
        }.to_json).create

        reports = EasyPost::Report.all(type: "shipment")

        reports["reports"].size.should be > 0
      end
    end
  end
end
