# encoding: utf-8
#------------------------------------------------------
require 'rubygems'
require 'bundler/setup'
#Bundler.setup(:default)
Bundler.require(:default)
#------------------------------------------------------
#
require './emwstfw/all.rb'

require './middleware'
require './db_actions'
require './dba_video.rb'

$DB = Redis.new driver: :hiredis, db: 11, :host => 'localhost', :port => 6379
$DBs = Mysql2::Client.new(:database => 'ruby_em',
                          :encoding => 'utf8',
                          :username => 'ruby_em',
                          :password => 'ruby_em',
                          :host     => '162.162.162.1',
                          :port     => 3306
                         )

$DBs.query_options.merge!(:symbolize_keys => true)

Template.cache false  #for development

EventMachine.run {
#  @channel = EM::Channel.new
  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 11777, :debug => false)  do |ws|
    MiddleWare.init(ws)
  end
  puts "Server started on http://0.0.0.0:11777/"
}

