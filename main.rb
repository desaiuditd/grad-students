require 'sinatra'
require 'sinatra/reloader' if development?

get '/' do
  erb :index
end

not_found do
  erb :_404
end
