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

def strans_login_stub
  stub_request(:post, "https://api.inthegra.strans.teresina.pi.gov.br/v1/signin")
  .to_return(body:'{"token": "87d19cf0-59f1-434b-9250-54b35902154c", "minutes": 10}')
end

def strans_vehicles_stub
  stub_request(:get, "https://api.inthegra.strans.teresina.pi.gov.br/v1/veiculos")
    .to_return(body: '[{
      "Linha": {
          "CodigoLinha": "0618",
          "Denomicao": "HD-PROMORAR SHOPPING VIA MIGUEL ROSA",
          "Origem": "PROMORAR",
          "Retorno": "SHOPPING",
          "Circular": true,
          "Veiculos": [{
            "CodigoVeiculo": 101,
            "Lat": "-5.14842000",
            "Long": "-42.79380000",
            "Hora": "'+Time.now.hour.to_s+':'+Time.now.min.to_s+'"
          },
          {
            "CodigoVeiculo": 102,
            "Lat": "-5.08364000",
            "Long": "-42.78894000",
            "Hora": "'+Time.now.hour.to_s+':'+Time.now.min.to_s+'"
          },
          {
            "CodigoVeiculo": 666,
            "Lat": "-5.08364000",
            "Long": "-42.78894000",
            "Hora": "00:00"
          }]
      }
    }]')
end