require 'json'

class ItemsController < ApplicationController
  def index
    file_path = Rails.root.join('resources','items.json').to_s
    file = File.read(file_path)
    items = JSON.parse(file)
    @items = items['items']
  end
end
