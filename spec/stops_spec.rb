# frozen_string_literal: true

describe :stops do
  before(:all) do
    a = Stop.create(code: "1", description: "A", address: "A", lat: "-5.062577", long: "-42.795527")
    b = Stop.create(code: "2", description: "B", address: "B", lat: "-5.062454", long: "-42.793862")
    c = Stop.create(code: "3", description: "C", address: "C", lat: "-5.05895", long: "-42.795047")
    Line.create(code: "5", description: "RED", return: "PC BANDEIRA", origin: "RED", stops: [a])
    Line.create(code: "6", description: "ROD", return: "UNIV", origin: "ROD", stops: [b, c])
    Line.create(code: "7", description: "ALTO", return: "MUCAM", origin: "ALTO", stops: [a])
  end

  after(:all) do
    truncate(Stop)
    truncate(Line)
    truncate(Checkin)
    truncate_table("lines_stops")
  end

  context "GET /stops" do
    it "when codes empty return all stops" do
      get "/v2/stops", token_head
      expect_status(200)
      expect_json_types(stops: :array_of_objects)
      expect_json_sizes(stops: 3)
    end

    it "should be return all stops with codes in order asc" do
      get "/v2/stops?codes[]=3&codes[]=1", token_head
      expect_status(200)
      expect_json_types(stops: :array_of_objects)
      expect_json_sizes(stops: 2)
      expect_json("stops.0", code: ->(code) { expect(code).to eq("1") })
      expect_json("stops.1", code: ->(code) { expect(code).to eq("3") })
    end

    it "should be return empty if codes not exists" do
      get "/v2/stops?codes[]=108&codes[]=104", token_head
      expect_status(200)
      expect_json_types(stops: :array_of_objects)
      expect_json_sizes(stops: 0)
    end
  end

  context "GET /stops/:id/lines" do
    it "should be return all lines in stop" do
      get "/v2/stops/1/lines", token_head
      expect_status(200)
      expect_json_types(lines: :array_of_objects)
      expect_json_sizes(lines: 2)
      expect_json("lines.0", code: ->(code) { expect(code).to eq("5") })
      expect_json("lines.1", code: ->(code) { expect(code).to eq("7") })
    end

    it "should be return 404 if stop not exist" do
      get "/v2/stops/9/lines", token_head
      expect_status(404)
    end
  end

  context "GET /closest" do
    it "should be return stops closet coordinate with dist" do
      get "/v2/stops/closest?lat=-5.062793&long=-42.795623&dist=500", token_head
      expect_status(200)
      expect_json_types(stops: :array_of_objects)
      expect_json_sizes(stops: 3)
    end

    it "should be not return stops out dist" do
      get "/v2/stops/closest?lat=-5.062793&long=-42.795623&dist=200", token_head
      expect_status(200)
      expect_json_types(stops: :array_of_objects)
      expect_json_sizes(stops: 2)
    end

    it "should be not return stops out dist coordinates" do
      get "/v2/stops/closest?lat=-5.0&long=-41.0&dist=200", token_head
      expect_status(200)
      expect_json_types(stops: :array_of_objects)
      expect_json_sizes(stops: 0)
    end
  end

  context "POST /v2/:code/checkin" do
    it "should be new checi associate to stop" do
      post "/v2/stops/2/checkin", {}, token_head
      expect_status(201)
      checkin = Checkin.where(stop: Stop.find_by_code(2)).last
      expect checkin
      expect checkin.stop.code == "101"
    end

    it "should be return 404 when code stop not found" do
      post "/v2/stops/9/checkin", {}, token_head
      expect_status(404)
    end
  end
end
