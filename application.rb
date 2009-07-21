require 'rubygems'
require 'sinatra'
require 'lib/twittermancy'

get '/' do
  erb :index
end

post '/' do
  puts "PARAMS: #{params[:text]}"
  @query = params[:text]
  unless @query.blank?
    @results = Divination.new(URI.escape(@query)).results
    if @results.blank?
      @error = "No results for that keyword!"
    end
  else
    @error = "No keyword specified!"
  end
  erb :index
end

get '/:search.json' do
  words = Divination.new(params[:search])
  words.results.to_json
end

error do
  @error = 'Sorry there was a nasty error - ' + env['sinatra.error'].message
  erb :index
end
