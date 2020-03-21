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
  truncate_table(model.table_name)
end

def truncate_table(table)
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table} RESTART IDENTITY CASCADE;")
end