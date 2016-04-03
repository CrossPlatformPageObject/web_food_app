require 'json'
require 'pry'

class ItemsController < ApplicationController
	@@items = {}
	def set_items
		file_path = Rails.root.join('resources', 'items.json').to_s
		items     = JSON.parse(File.read(file_path))
		@@items   = items['items']
	end

	def index
		 @items = @@items.empty? ? set_items : @@items
	end

	def show
		@item = @@items.find { |item| item['name'] == params['name'] }
	end

end
