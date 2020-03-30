# frozen_string_literal: true

describe :vehicles do
  before(:all) do
    strans_login_stub
    strans_vehicles_stub
  end

  after(:all) do
    truncate(Vehicle)
    truncate(Checkin)
  end

  context "GET /" do
    it "should be save new vehicles" do
      get "/v2/vehicles/", token_head
      expect Vehicle.find_by_code!("101")
      expect Vehicle.find_by_code!("102")
    end

    it "should not be save new vehicles invalids" do
      get "/v2/vehicles/", token_head
      expect { Vehicle.find_by_code!("666") }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "should be reutrn all vehicles on-line" do
      get "/v2/vehicles/", token_head
      expect_status(200)
      expect_json_types(vehicles: :array_of_objects)
      expect_json_sizes(vehicles: 2)
    end

    it "should be reutrn all vehicles on-line in 5 min" do
      get "/v2/vehicles/", token_head
      expect_status(200)
      expect_json("vehicles.0", code: ->(code) { expect(code).not_to eq("666") })
      expect_json("vehicles.1", code: ->(code) { expect(code).not_to eq("666") })
    end
  end

  context "GET /:code" do
    it "should be reutrn vehicles on-line with code" do
      get "/v2/vehicles/102", token_head
      expect_status(200)
      expect_json("vehicle.code", "102")
    end

    it "should not be reutrn vehicles off-line" do
      get "/v2/vehicles/666", token_head
      expect_status(404)
    end
  end

  context "POST :code/checkin" do
    it "should be new checkin associate to vehicle online" do
      post "/v2/vehicles/101/checkin", {}, token_head
      expect_status(201)
      checkin = Checkin.where(vehicle: Vehicle.find_by_code("101")).first
      expect checkin
      expect checkin.vehicle.code == "101"
    end

    it "should be return 404 when code vehicle not online" do
      post "/v2/vehicles/1/checkin", {}, token_head
      expect_status(404)
    end
  end
end
