# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

RubyTestSt::Application.load_tasks


require 'fileutils'

task default: :coffee





desc "Compile the CoffeeScript files into JavaScript"
task :coffee do
  sh "coffee --watch --compile --output ./public/app/   ./public/app.src/"
end

desc "Compile the scss files into css"
task :scss do
  sh "sass --watch ./public/app.src/:./public/app/"
end

desc "Compile the jade files into html"
task :jade do
  sh "jade -P --watch ./public/app.src --out ./public/app"
end

