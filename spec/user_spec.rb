# frozen_string_literal: true

describe :users do
  it "POST / should be create a new user." do
    post "/v2/users", { name: "user", email: "user@mail.com", password: "pass" }, token_head
    expect_status(201)
    expect User.all.select { |app| app.email == "user@mail.com" }
  end

  it "GET / should return all user's users" do
    get "/v2/users", token_head
    expect_status(200)
    expect_json_types(users: :array_of_objects)
  end

  it "GET /:id should return return new the user with id" do
    get "/v2/users/1", token_head
    expect_status(200)
    expect_json("user.id", 1)
  end

  it "PUT /:id should update user with id user" do
    new_user = User.create(name: "name", email: "user@mail.com", password_hash: "pass")
    params = { name: "new name", email: "user@mail.com", password: "pass", active: true }
    put "/v2/users/#{new_user.id}", params, token_head
    expect_status(200)
    expect_json("user.name", "new name")
    expect_json("user.email", "user@mail.com")
    expect_json("user.active", true)
  end

  it "DELETE /:id alter attribute active to false" do
    delete "/v2/users/1", {}, token_head
    expect_status(200)
    user = User.find(1)
    expect user.active == false
  end

  it "POST /:id/sugestion should be create a new user's sugestion." do
    post "/v2/users/1/sugestion", { email: "user@mail.com", text: "textao ..." }, token_head
    expect_status(201)
    expect Sugestion.where(user: User.find(1))
  end
end
