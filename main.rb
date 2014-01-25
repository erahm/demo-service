require 'sinatra'
require 'sinatra/reloader' if development?
require 'mongoid'
require 'slim'
require 'redcarpet'
 
configure do
  Mongoid.load!("./mongoid.yml")
end

class Creature
	include Mongoid::Document

	field :type, type: String
	field :name, type: String
	field :age, type: Integer
	field :photo, type: String
end

post '/creature', :provides => :json do
	content_type :json
	params = request.body.string

	halt 400 if params.length == 0

	data = Json.parse(params)

	creature = Creature.new(type: data['type'], name: data['name'], age: data['age'], photo: data['photo'])
	creature.save


	halt 200, creature.to_json

end
	
get '/creatures', :provides => :json do
	content_type :json

	creatures = Creature.all

	if creatures.length > 0
		halt 200, creatures.to_json
	else
		halt 200
	end
end

get '/creature/name/:name' do
	content_type :json
	@name = params[:name]
	creature = Creature.where(:name => @name)

	halt 200, creature.to_json
end