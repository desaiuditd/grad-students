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

DataMapper.finalize

DataMapper.auto_upgrade!

get '/students' do
  @students = Student.all
  erb :students
end

post '/students' do
  @student = Student.create(params[:student])
  redirect to('/students')
end

get '/students/new' do
  @student = Student.new
  erb :new_student
end

get '/students/:id' do
  @student = Student.get(params[:id])
  erb :show_student
end

put '/students/:id' do
  @student = Student.get(params[:id])
  @student.update(params[:student])
  redirect to('/students/'+params[:id])
end

delete '/students/:id' do
  Student.get(params[:id]).destroy
  redirect to('/students')
end

get '/students/:id/edit' do
  @student = Student.get(params[:id])
  erb :edit_student
end

