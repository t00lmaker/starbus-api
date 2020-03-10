require 'bcrypt'

# password do root carregado do ambiente.
root_pass = ENV['ROOT_PASS']

# encriptografa o password com o sal.
hash_pass = BCrypt::Password.create(root_pass)

# Cria o usuario root inicial 
root = User.create(name: 'root', username: 'root', password_hash: hash_pass, email: 'luanpontes2@gmail.com') 

# Cria a aplicação root, que é a aplicação padrão para manipulação de usuarios e aplicações na plataforma
Application.create(name: 'Starbus', key: 'starbus', ownner: root, description: 'Apllication Root')