# encoding: utf-8
#------------------------------------------------------
require 'rubygems'
require 'bundler/setup'
#Bundler.setup(:default)
Bundler.require(:default)
#------------------------------------------------------
require './db_actions'
#--------------------------------------------

$DB = Redis.new driver: :hiredis, db: 11, :host => 'localhost', :port => 6379

$DBs = Mysql2::Client.new(:database => 'ruby_em',
                          :encoding => 'utf8',
                          :username => 'ruby_em',
                          :password => 'ruby_em',
                          :host     => '162.162.162.1',
                          :port     => 3306
                         )

$DBs.query_options.merge!(:symbolize_keys => true)

def fill_db
  $DB.flushdb
  a = ['Стратегии','Аркады','Экшен','Симуляторы','Викторины','Гонки']
  a.each do |n|
    DBWork.create_cat n
  end
  uu = ['john','mark','petya','vasya','vladimir']
  uu.each do |n|
    DBWork.create_user n,n
  end
  g = ['Tetris','Mario','Need for speed','Crysis','Battle City','Line Age','Shadow Warrior','KillZone','Mass Effect','Splinter Cell','Quake','Heretic']
  g.each  do |n|
    i = DBWork.create_item n, (n+' ')*5,1+rand(2),rand(2)+1,rand(3)
    if rand(7) < 5
      DBWork.item_approve i
      5.times do |u|      
        DBWork.item_vote i, u, 1+rand(5)
        DBWork.item_load i, u
        DBWork.create_comment i, u, "#{uu[u]} #{a[rand(5)]}"*5
      end
    end
  end
end

fill_db

