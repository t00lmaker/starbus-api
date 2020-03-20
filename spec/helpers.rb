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

def truncate(model)
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{model.table_name} RESTART IDENTITY;")
end