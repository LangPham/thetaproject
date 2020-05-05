# Theta Elixir
Project web blog for https://theta.vn

## Getting started
Create project Phoenixframework with --umbrella --database=postgres

Config database in config/dev.exs (pord.exs)
 

To start your Theta server:

* Install dependencies with `mix deps.get`
* Create your database with `mix thetainstall`
* Install Node.js dependencies with `cd apps/theta_web/assets && npm install`
* Start Phoenix endpoint with `mix phx.server`

Access http://127.0.0.1:4000/sessions/new
* Username: `admin@theta.vn`
* Password: `password`

Access http://127.0.0.1:4000/cms/admin
* Create term in taxonomy "Main menu"
* Create article with markdown editor

## Todo: 
* Add summary for article 
* Add term tag
* Add role for user
* Add config theme for web
