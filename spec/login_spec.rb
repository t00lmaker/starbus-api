# frozen_string_literal: true

describe :login do
  it "POST / should be return a string" do
    post "/v2/login", { application: "starbus", username: "root", password: "" }
    expect_status(201)
    expect_json_types(token: :string)
  end

  it "POST / should be return 401 when use or pass invalid" do
    post "/v2/login", { application: "starbus", username: "invalid", password: "" }
    expect_status(403)
    post "/v2/login", { application: "starbus", username: "root", password: "invalid" }
    expect_status(403)
  end
end
