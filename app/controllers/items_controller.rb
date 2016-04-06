require 'json'
require 'pry'

class ItemsController < ApplicationController
	@@items              = {}
	@@payment_preference = 'CASH'

	def set_items
		file_path = Rails.root.join('resources', 'items.json').to_s
		items     = JSON.parse(File.read(file_path))
		@@items   = items['items']
		clear_and_initialize_session
	end

	def clear_and_initialize_session
		session.delete('items') if session.key? 'items'
		session.delete('cart') if session.key? 'cart'
		session.delete('user_details') if session.key? 'user_details'
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
		session['cart']      = @cart
		@cart
	end

	def payment_pref
	end

	def save_payment_pref
		@@payment_preference = params['payment']
		flash[:success]      = "Payment preference saved: #{@@payment_preference}"
		redirect_to items_index_path
	end

	def checkout
		render 'user_details'
	end

	def save_user_details
		user_details            = {}
		user_details['name']    = params['name']
		user_details['address'] = params['address']
		session['user_details'] = user_details
		if (@@payment_preference == 'CASH') then
			render 'summary'
		else
			render 'credit_card'
		end
	end

	def save_credit_card_details
		# show message as payment successful if  @@payment_preference = 'CREDIT'
		render 'summary'
	end

	def summary
		@cart         = session['cart']
		@user_details = session['user_details']
	end
end
