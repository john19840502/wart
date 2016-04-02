# encoding: utf-8
#------------------------------------------------------
require 'rubygems'
require 'bundler/setup'
#Bundler.setup(:default)
Bundler.require(:default)
#------------------------------------------------------
require './db_actions'
require './dba_video.rb'
#--------------------------------------------
$DB = Redis.new driver: :hiredis, db: 11, :host => 'localhost', :port => 6379

class VideoBGTranscoder

  def self.handle_video(id,sec)
    vfn = "#{id},#{sec}"
    queue = "./queue/#{vfn}"
    publ = "../public/video/{vfn}"
    options_mp4 = {
        video_codec: 'libx264',
        custom: '-f mp4 -strict -2 -vf "movie=./wmark.png [watermark]; [in][watermark] overlay=main_w-overlay_w-10:main_h-overlay_h-10 [out]" -movflags faststart'
    }
    options_webm = {
        custom: '-vf "movie=./wmark.png [watermark]; [in][watermark] overlay=main_w-overlay_w-10:main_h-overlay_h-10 [out]" '
    }
    options_ogv = options_webm
    movie = FFMPEG::Movie.new(queue)
    movie.transcode "#{publ}.mp4" , options_mp4
    movie.transcode "#{publ}.webm", options_webm
    movie.transcode "#{publ}.ogv" , options_ogv

 #   movie.transcode "#{publ}.flv", options)#,transcoder_options)
 #   system "flvtool2 -U #{publ}.flv"

    File.delete queue
    DBWork.set_video_prepared id
  end

  def self.handle_list
    loop do
      puts 'checking..'
      id,sec=DBWork.get_video_to_prepare
      while id
        puts "handle #{id}"
        handle_video id,sec
        
        id,sec=DBWork.get_video_to_prepare
      end
      puts 'sleep'
      sleep(2)
    end
  end  

  def self.start
    handle_list
  end

end  

VideoBGTranscoder.start
