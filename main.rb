require 'sinatra'
require 'mongoid'
require 'json'
require_relative 'creature'
 
configure do
  Mongoid.load!("./mongoid.yml")
end

get '/creatures' do
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
	validateParams(params)
	name = params[:name]
	creature = Creature.where(:name => name)

	halt 200, creature.to_json
end

get '/creature/id/:id' do
	content_type :json
	validateParams(params)
	
	id = params[:id]

	creature = Creature.where(:_id => id)

	halt 200, creature.to_json
end

post '/creature' do
	content_type :json

	data = parseRequest(request)

	creature = Creature.new(type: data['type'], name: data['name'], age: data['age'], photo: data['photo'])
	creature.save

	halt 200, creature.to_json

end

put '/creature' do
	content_type :json

	data = parseRequest(request)

	creature = Creature.where(:_id => data['_id'])
	creature.update(name: data['name'], type: data['type'], age: data['age'], photo: data['photo'])

	halt 200, creature.to_json
end

delete '/creature' do
	content_type :json

	data = parseRequest(request)

	Creature.where(:type => data['type'], :name => data['name'], :age => data['age'], :photo => data['photo']).delete

	halt 200

end

delete '/creature/id/:id' do
	content_type :json

	id = params[:id]

	Creature.where(:_id => id).delete

	halt 200

end

def validateParams (params)
	halt 400 if params.length == 0
end

def parseRequest (request)
	return JSON.parse(request.body.string)
end