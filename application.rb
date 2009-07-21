require 'rubygems'
require 'sinatra'
require 'lib/twittermancy'

get '/' do
  erb :index
end

post '/' do
  @query = params[:text]
  @results = Divination.new(URI.escape(@query)).results
  erb :index
end

get '/:search.json' do
  words = Divination.new(params[:search])
  words.results.to_json
end

error do
  'Sorry there was a nasty error - ' + env['sinatra.error'].name
end