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

# define SCSS template to compile css
get '/css/:styles.css' do |styles|
  scss :"scss/#{styles}"
end

# before filter to check for current logged in user
# if not logged in then redirect to login page
before do
  # print method - POST / GET etc.
  # puts request.request_method
  # check for authentication. ignore css paths as well
  unless ['/','/login','/logout','/about','/contact'].include?(request.path_info) or request.path_info.include?('/css/')
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
    redirect '/students'
  else
    # invalid login. show errors.
    session[:login_error] = "Invalid login credentials. Please try again with same string for Email & Password."
    redirect '/login'
  end

end

# logout route
get '/logout' do
  session[:current_user_auth] = nil
  redirect '/login'
end

# about route
get '/about' do
  erb :about
end

# contact route
get '/contact' do
  erb :contact
end

# define 404 not found route & template
not_found do
  erb :_404
end
