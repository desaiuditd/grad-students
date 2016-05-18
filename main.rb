require 'sinatra'
require 'sinatra/reloader' if development?
require 'sass'

get '/' do
  erb :index
end

get '/css/:styles.css' do |styles|
  scss :"scss/#{styles}"
end

not_found do
  erb :_404
end
