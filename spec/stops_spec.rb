describe :stops do 
 
  before(:all) do
    s1 = Stop.create(code: "100", description: "Av A p1", address: "Av. A", lat: "-5.062577", long: "-42.795527")
    s2 = Stop.create(code: "101", description: "R B p44", address: "R. B", lat: "-5.062454", long: "-42.793862")
    s3 = Stop.create(code: "102", description: "R C p75", address: "R C", lat: "-5.05895", long: "-42.795047")
    Line.create(code: "505", description: "REDONDA", return: "PRACA BANDEIRA", origin: "REDONDA", stops: [s1])
    Line.create(code: "327", description: "RODOVIARIA", return: "UNIVERSIDADE", origin: "RODOVIARIA", stops: [s2, s3])
    Line.create(code: "503", description: "ALTO DA RESSU", return: "mocambinho", origin: "ALTO", stops: [s1])
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
      get "/v2/stops?codes[]=102&codes[]=100", token_head
      expect_status(200)
      expect_json_types(stops: :array_of_objects)
      expect_json_sizes(stops: 2)
      expect_json("stops.0", code: -> (code){ expect(code).to eq("100")})
      expect_json("stops.1", code: -> (code){ expect(code).to eq("102")})
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
      get "/v2/stops/100/lines", token_head
      expect_status(200)
      expect_json_types(lines: :array_of_objects)
      expect_json_sizes(lines: 2)
      expect_json("lines.0", code: -> (code){ expect(code).to eq("503")})
      expect_json("lines.1", code: -> (code){ expect(code).to eq("505")})
    end

    it "should be return 404 if stop not exist" do
      get "/v2/stops/1/lines", token_head
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
      post "/v2/stops/101/checkin", {}, token_head
      expect_status(201)
      checkin = Checkin.where(stop: Stop.find_by_code(101)).last
      expect checkin
      expect checkin.stop.code == "101"
    end

    it "should be return 404 when code stop not found" do
      post "/v2/stops/1/checkin", {},  token_head
      expect_status(404)
    end
  end
end