require 'rubygems'
require 'sinatra'
require 'lib/twittermancy'

get '/' do
  erb :index
end

post '/' do
  @results = Divination.new(params[:text]).results
  @query = params[:text]
  erb :results
end

get '/:search.json' do
  words = Divination.new(params[:search])
  words.results.to_json
end