# StarBus API - 0.0.1

Uma plataforma de crowdsourcing para usuário de transporte público de Teresina.

### Organização

StarBus é formada por três componentes principais:

#### Apps
  Aplicativos iOs e Android em que usuários utilizar em seus smartphones em que
  os usuários de transporte publico pode interagir entre si e com a estrutura
  de transport público local.  

#### Dashboard
  Dados públicos sobre o transporte público local construidos pela utilização da
  dos app, que são mostrados de forma a gerar informação relevante para a sociedade.

#### API
  Core do Starbus que deve pode ser acessada via App, Dashboard e por outras aplições de
  outros produtores de software. Oferece as informações que alimentam a plataforma.  

Esse repositorio guarda a api e a landpage do projeto.

### O que você pode encontrar nesse repositorio ?

 * Uma API implementada com o framwork [Grape](http://www.ruby-grape.org)
 * Teste de uma api utilizando Rspec e [Airborne](https://github.com/brooklynDev/airborne)
 * Uma API e uma aplicação rodando no mesmo servidor, utilizando dois frameworks diferentes Grape e Sinatra.


 ### Comandos ulteis



Avalia o codigo e corrige o que pode ser corrigido.
bundle exec rubocop -a -x

Corrige o formatação codigo.
bundle exec rufo .

Setup banco em test
rake db:setup RAILS_ENV=test

Seeds banco de dados em test.
rake db:seed RAILS_ENV=test


