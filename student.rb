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
  property :GPA, Float

end

DataMapper.finalize

DataMapper.auto_migrate!
DataMapper.auto_upgrade!

get '/students' do
  @students = Student.all
  puts "yoyo"
  puts @students
  puts "yoyo"
  erb :students
end

