require 'rubygems'
require 'sinatra'
require 'lib/twittermancy'
require 'yaml'

ga_config = YAML.load(File.read(APP_ROOT + "config/googleanalytics.yml"))
if ga_config
  google_analytics_id = ga_config.first
end

before do
  @google_analytics_id = google_analytics_id
end

get '/' do
  erb :index
end

post '/' do
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
