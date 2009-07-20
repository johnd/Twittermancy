require 'rubygems'
require 'sinatra'
require 'lib/twittermancy'

get '/:search.json' do
  words = Divination.new(params[:search])
  words.results.to_json
end