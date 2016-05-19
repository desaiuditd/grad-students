require 'sinatra'
require 'sinatra/reloader' if development?
require 'sass'

enable :sessions

use Rack::Session::Pool, :expire_after => 365 * 24 * 60 * 60 # expire after 1 year in seconds

set :session_secret, 'super grad students secret'

get '/css/:styles.css' do |styles|
  scss :"scss/#{styles}"
end

before do
  # print method - POST / GET etc.
  puts request.request_method
  # check for authentication
  if ['/'].include?(request.path_info)
    puts "checking for authentication"
    if session[:current_user_auth].nil?
      puts "no user found. so redirect to login"
      redirect '/login'
    end
  end
end

get '/' do
  erb :index
end

get '/login' do
  erb :login
end

post '/login' do
  email = params[:email]
  password = params[:password]

  if email == password
    # save session & redirect
    session[:current_user_auth] = 'user exists'
    redirect '/'
  else
    # invalid login. show errors.
  end

end

get '/logout' do
  session[:current_user_auth] = nil
  redirect '/login'
end

not_found do
  erb :_404
end
