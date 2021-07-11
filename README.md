# README

#Generate a new api
rails new testapp --api -T -d mysql

#Go to config/database.yml to add MySQL password 
password: S00n3rs0ft!

#Create database
rails db:create

#Also install Gemfile dependencies
bundle install

#Start rails server to make sure you get the Yay! You’re on Rails! page
rails server (or rails s)
Ctrl + c to kill the server

#Generate a new controller
rails g controller api

#Go to app/controllers/application_controller.rb and change from using API to using Base
class ApplicationController < ActionController::Base
end

#Go to app/controllers/api_controller.rb and change ApplicationController to inherit from ActionController
class ApiController < ActionController::API
end

#Go to config/application.rb and the following middleware at the end 
config.middleware.use Rack::MethodOverride
config.middleware.use ActionDispatch::Flash
config.middleware.use ActionDispatch::Cookies
config.middleware.use ActionDispatch::Session::CookieStore

#Also in config/application.rb, uncomment the following
require "sprockets/railtie"

#Add ActiveAdmin gem to Gemfile and then update Gemfile by running bundle install
gem 'activeadmin'
bundle install

#Also add Sprockets dependency to Gemfile for Sprockets error
gem "sprockets", "<4"
bundle update sprockets

#Next add sassc-rails dependency to Gemfile before the gem 'rails' line for Sassc error
gem 'sassc-rails'
bundle update

#After updating your bundle, run the installer with skip-users since we do not want to Devise
rails g active_admin:install --skip-users

#Then migrate and seed your database before starting the server:
rails db:migrate
	rails db:seed
	rails server (or rails s)

#Go to config/application.rb and add the following
config.app_generators.scaffold_controller = :scaffold_controller

#Generate a model for Drink
rails g scaffold Drink title:string description:text steps:text source:string

#Generate another model for Ingredients
rails g scaffold Ingredient drink:references description:text

#Add has_many to app/models/drink.rb to associate Drink with Ingredients
class Drink < ApplicationRecord
  has_many :ingredients
end

#Then migrate the database and configure the resource
rails db:migrate
rails generate active_admin:resource Drink
rails generate active_admin:resource Ingredient

#Go to app/admin/drinks.rb and uncomment the following to permit ActiveAdmin to change your model 
permit_params :title, :description, :steps, :source

#Go to app/admin/ingredient.rb and uncomment the following to permit ActiveAdmin to change your model 
permit_params :description, :drink_id

#To be able to edit Drinks, we need to set up an API call to drinks resource in config/routes.rb
 scope '/api' do
    resources :drinks
 end
#Restart server and you should go to the following url. You will see 2 brackets
rails server (or rails s)
http://localhost:3000/api/drinks

#Go to db/seeds.rb and create seeds for Drinks
negroni = Drink.create(
  title: "Sparkling Negroni",
  description: "The perfect cocktail for sipping after an alfresco dinner on a summer night, Negronis get their red hue and herbaceous beginning from the Italian apéritif Campari, which is mellowed out by floral gin and sweet vermouth. Top off your drink with some bubbly, and enjoy.",
  steps: "Combine the first three ingredients in an ice-filled cocktail shaker. Shake until cold, then strain the mixture into a glass. Top with prosecco, and garnish with the orange twist.",
  source: "http://www.architecturaldigest.com/gallery/4-easy-entertaining-summer-cocktail-recipes-5-ingredients-or-less",
)
negroni.ingredients.create(description: "⅓ oz. Campari")
negroni.ingredients.create(description: "⅓ oz. gin")
negroni.ingredients.create(description: "⅓ oz. sweet vermouth")
negroni.ingredients.create(description: "Chilled prosecco, or other sparkling wine, for topping")
negroni.ingredients.create(description: "Orange peel twist (optional)")

margarita = Drink.create(
  title: "Pineapple-Jalapeño Margarita",
  description: "No margarita is complete without fresh-squeezed lime juice—there’s something about the sour punch of citrus that goes so well with the smokiness of tequila. To stir things up, try adding pineapple juice to the mix and muddling in some jalapeño peppers for a little heat.",
  steps: "Pour the lime juice and jalapeños into a shaker and muddle with the back of a wood spoon. Fill with ice. Pour in tequila, pineapple juice, and Grand Marnier. Shake until chilled. Dip the rim of a rocks glass in water, then dip it in coarse salt. Fill the glass with ice, and strain the cocktail into the glass. Garnish with pineapple wedge and peel and jalapeño slices.",
  source: "http://www.architecturaldigest.com/gallery/4-easy-entertaining-summer-cocktail-recipes-5-ingredients-or-less"
)
margarita.ingredients.create(description: "½ oz. fresh lime juice")
margarita.ingredients.create(description: "⅓ of a large jalapeño, sliced, plus more for garnish")
margarita.ingredients.create(description: "1¾ oz. tequila")
margarita.ingredients.create(description: "1½ oz. fresh pineapple juice")
margarita.ingredients.create(description: "½ oz. Grand Marnier or other orange liqueur")
margarita.ingredients.create(description: "Coarse salt, for rimming glass")
margarita.ingredients.create(description: "Pineapple wedge and peel, for garnish")

#Next run the command to seed the database and refresh web browser page
	rails db:seed

#Go back to app/controllers/drinks_controller.rb and change the DrinksController to inherit from ApiController. Also, add the following and delete the rest of the code
 class DrinksController < ApiController

    # GET /drinks
    def index
      @drinks = Drink.select("id, title").all
      render json: @drinks.to_json
  end

    # GET /drinks/1
    def show
      @drink = Drink.find(params[:id])
       render json: @drink.to_json(:include => { :ingredients => { :only => [:id, :description] }})
  end
end

#Then, delete all the code from  app/controllers/ingredients_controller.rb and change IngredientsController to inherit from ApiController
class IngredientsController < ApiController  
end
# testapp
