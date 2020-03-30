# frozen_string_literal: true

describe :applications do
  it "POST / should be create a new application." do
    post "/v2/applications", { name: "newapp", description: "a new application" }, token_head
    expect_status(201)
    expect Application.all.select { |app| app.name == "newapp" }
  end

  it "GET / should return all user's applications" do
    get "/v2/applications", token_head
    expect_status(200)
    expect_json_types(applications: :array_of_objects)
  end

  it "GET /:id should return return new the application with id" do
    get "/v2/applications/1", token_head
    expect_status(200)
    expect_json("application.id", 1)
  end

  it "PUT /:id should update application with id application" do
    put "/v2/applications/1", { name: "updated", description: "new desc", active: true }, token_head
    expect_status(200)
    expect_json("application.name", "updated")
  end

  it "DELETE /:id alter attribute active to false" do
    delete "/v2/applications/1", {}, token_head
    expect_status(200)
    app = Application.find(1)
    expect app.active == false
  end
end
