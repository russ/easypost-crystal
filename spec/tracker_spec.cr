require "./spec_helper"

describe EasyPost::Tracker do
  describe "#create" do
    it "tracks" do
      EightTrack.use_tape("tracker-create-tracks") do
        tracker = EasyPost::CreateTrackerOptions.from_json({
          tracking_code: "EZ2000000002",
          carrier:       "USPS",
        }.to_json).create

        tracker.carrier.should eq("USPS")
        tracker.tracking_code.should eq("EZ2000000002")
        tracker.status.should eq("in_transit")
        tracker.tracking_details.not_nil!.size.should be > 0
      end
    end
  end

  describe "#index" do
    it "retrieves a full page of trackers" do
      EightTrack.use_tape("retrieves-a-full-page-of-trackers") do
        trackers = EasyPost::Tracker.all

        trackers["trackers"].size.should eq(30)
        trackers["has_more"].should eq(true)
      end
    end

    it "retrieves all trackers with given tracking code, up to a page" do
      EightTrack.use_tape("retrieves-all-trackers-with-given-tracking-code-up-to-a-page") do
        trackers = EasyPost::Tracker.all({page_size: 5, tracking_code: "EZ2000000002"})

        trackers["trackers"].size.should eq(5)
        trackers["has_more"].should eq(true)
      end
    end

    it "retrieves all trackers with given tracking code and carrier, up to a page" do
      EightTrack.use_tape("retrieves-all-trackers-with-given-tracking-code-and-carrier-up-to-a-page") do
        trackers = EasyPost::Tracker.all({page_size: 5, tracking_code: "EZ2000000002", carrier: "USPS"})

        trackers["trackers"].size.should eq(5)
        trackers["has_more"].should eq(true)
      end
    end

    it "retrieves trackers correctly based on datetime" do
      EightTrack.use_tape("retrieves-trackers-correctly-based-on-datetime") do
        tracker = EasyPost::CreateTrackerOptions.from_json({
          tracking_code: "EZ2000000002",
          carrier:       "USPS",
        }.to_json).create

        trackers = EasyPost::Tracker.all({
          start_datetime: tracker.created_at.not_nil!,
          tracking_code:  "EZ2000000002",
        })

        trackers["trackers"].size.should eq(1)
        trackers["trackers"].as(Array(EasyPost::Tracker)).first.id.should eq(tracker.id)
        trackers["has_more"].should eq(false)

        trackers = EasyPost::Tracker.all({
          end_datetime:  tracker.created_at.not_nil!,
          tracking_code: "EZ2000000002",
        })

        trackers["trackers"].size.should eq(19)
        trackers["trackers"].as(Array(EasyPost::Tracker)).each do |track|
          track.id.should_not eq(tracker.id)
        end
        trackers["has_more"].should eq(false)
      end
    end

    it "retrieves trackers correctly based on id" do
      EightTrack.use_tape("retrieves-trackers-correctly-based-on-id") do
        tracker_1 = EasyPost::CreateTrackerOptions.from_json({
          tracking_code: "EZ2000000002",
          carrier:       "USPS",
        }.to_json).create

        tracker_2 = EasyPost::CreateTrackerOptions.from_json({
          tracking_code: "EZ2000000002",
          carrier:       "USPS",
        }.to_json).create

        trackers = EasyPost::Tracker.all({
          after_id:      tracker_1.id,
          tracking_code: "EZ2000000002",
        })

        trackers["trackers"].size.should eq(1)
        trackers["trackers"].as(Array(EasyPost::Tracker)).first.id.should eq(tracker_2.id)
        trackers["trackers"].as(Array(EasyPost::Tracker)).first.id.should_not eq(tracker_1.id)
        trackers["has_more"].should be_false

        trackers = EasyPost::Tracker.all({
          before_id:     tracker_1.id,
          tracking_code: "EZ2000000002",
        })

        trackers["trackers"].size.should eq(20)
        trackers["trackers"].as(Array(EasyPost::Tracker)).each do |track|
          track.id.should_not eq(tracker_1.id)
          track.id.should_not eq(tracker_2.id)
        end
        trackers["has_more"].should eq(false)
      end
    end
  end
end
