require 'mongoid';

class Creature
	include Mongoid::Document

	field :type, type: String
	field :name, type: String
	field :age, type: Integer
	field :photo, type: String
end