# include sinatra library
require 'sinatra'
# include autoloader
require 'sinatra/reloader' if development?
# include scss library
require 'sass'
# include student related routes & model
require './student'

# setup Session variables for Login authentication
configure do
  enable :sessions

  use Rack::Session::Pool, :expire_after => 365 * 24 * 60 * 60 # expire after 1 year in seconds

  set :session_secret, 'super grad students secret'
end

# define db for development environment
configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

# define db for production (heroku) environment
configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3://#{Dir.pwd}/production.db')
end

# define SCSS template to compile css
get '/css/:styles.css' do |styles|
  scss :"scss/#{styles}"
end

# before filter to check for current logged in user
# if not logged in then redirect to login page
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

# Home Page route & template
get '/' do
  erb :index
end

# login page route & template
get '/login' do
  erb :login
end

# post method to process login
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

# logout route
get '/logout' do
  session[:current_user_auth] = nil
  redirect '/login'
end

# define 404 not found route & template
not_found do
  erb :_404
end
