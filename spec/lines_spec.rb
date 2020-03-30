# frozen_string_literal: true

describe :lines do
  before(:all) do
    Line.create(code: "505", description: "REDONDA", return: "PC BANDEIRA", origin: "REDONDA")
    Line.create(code: "327", description: "RODOVIARIA", return: "UNIVERSIDADE", origin: "ROD")
    Line.create(code: "503", description: "ALTO DA RESSU", return: "MOCABINHO", origin: "ALTO")
  end

  after(:all) do
    truncate(Line)
  end

  context "GET /lines" do
    it "when codes and search empty return all lines" do
      get "/v2/lines", token_head
      expect_status(200)
      expect_json_types(lines: :array_of_objects)
      expect_json_sizes(lines: 3)
    end

    it "should be return all lines with codes in order asc" do
      get "/v2/lines?codes[]=503&codes[]=327", token_head
      expect_status(200)
      expect_json_types(lines: :array_of_objects)
      expect_json_sizes(lines: 2)
      expect_json("lines.0", code: ->(code) { expect(code).to eq("327") })
      expect_json("lines.1", code: ->(code) { expect(code).to eq("503") })
    end

    it "should be return all lines with term search in order asc" do
      get "/v2/lines?search=universidade redonda", token_head
      expect_status(200)
      expect_json_types(lines: :array_of_objects)
      expect_json_sizes(lines: 2)
      expect_json("lines.0", code: ->(code) { expect(code).to eq("327") })
      expect_json("lines.1", code: ->(code) { expect(code).to eq("505") })
    end

    it "should return empity when code not exist" do
      get "/v2/lines?codes[]=5&codes[]=3", token_head
      expect_status(200)
      expect_json_types(lines: :array_of_objects)
      expect_json_sizes(lines: 0)
    end

    it "should return empty when term not exist" do
      get "/v2/lines?search=term", token_head
      expect_status(200)
      expect_json_types(lines: :array_of_objects)
      expect_json_sizes(lines: 0)
    end
  end
end
