require 'json'
require 'pry'

class ItemsController < ApplicationController
	@@items = {}
  @@payment_preference = 'CASH'
	def set_items
		file_path        = Rails.root.join('resources', 'items.json').to_s
		items            = JSON.parse(File.read(file_path))
		@@items          = items['items']
		session.delete('items')
		session['items'] = []
	end

	def index
		@items = @@items.empty? ? set_items : @@items
	end

	def show
		@item = @@items.find { |item| item['name'] == params['name'] }
	end

	def add
		item = @@items.find { |item| item['name'] == params['name'] }
		session['items'] << item
		redirect_to items_index_path
	end

	def cart
		@cart          = {}
		@cart['items'] = []
		price          = 0
		session['items'].each do |item|
			@cart['items'] << item
			price += item['price']
		end
		@cart['total_price'] = price
		@cart
	end

	def payment_pref
	end

	def save_payment_pref
		@@payment_preference = params['payment']
		flash[:success]= "Payment preference saved: #{@@payment_preference}"
		puts "Payment saved: #{@@payment_preference}"
		redirect_to items_index_path
	end
end
