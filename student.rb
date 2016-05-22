# include data mapper library
require 'dm-core'
require 'dm-migrations'

# setup db connection
if development?
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
elsif production?
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3://#{Dir.pwd}/production.db')
end

# Student model class for DataMapper
class Student
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :degree, String
  property :major, String
  property :graduation_year, Integer
  property :gpa, Float

end

# commit the changes for DB.
DataMapper.finalize

# upgrade the database for new changes
DataMapper.auto_upgrade!

# list all students route
get '/students' do
  @students = Student.all
  erb :students
end

# create new student route
post '/students' do
  @student = Student.create(params[:student])
  redirect to('/students')
end

# route for the form to create new student
get '/students/new' do
  @student = Student.new
  erb :new_student
end

# show single student route
get '/students/:id' do
  @student = Student.get(params[:id])
  erb :show_student
end

# edit single student route
put '/students/:id' do
  @student = Student.get(params[:id])
  @student.update(params[:student])
  redirect to('/students/'+params[:id])
end

# delete single student route
delete '/students/:id' do
  Student.get(params[:id]).destroy
  redirect to('/students')
end

# route for the form to edit single student
get '/students/:id/edit' do
  @student = Student.get(params[:id])
  erb :edit_student
end

