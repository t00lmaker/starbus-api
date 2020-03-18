# retorn token to authentication.
def token_head(user=nil, app=nil)
  user ||= User.first
  app  ||= Application.first
  payload = { 
    user_id: user.id,
    app_id:  app.id
  }
  { "Authorization" =>  "Bearer #{JWT.encode(payload, nil, 'none')}"} 
end