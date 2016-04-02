# encoding: utf-8

class MiddleWare

  include EMWSFW::Action
  include EMWSFW::Responce
  include EMWSFW::Request
  include EMWSFW::Binary

  def initialize (ws)
    @ws = ws
  end

  def deffered?(request)
    unless has_binary? request
      # future check and post to handling other deffered actions
    else
      return true
    end
    false
  end

  def onopen(connection)
    puts "Connected at #{Time.new.strftime('%d.%m.%Y %H:%M:%S')}"
  end

  def onmessage(request)
     handle_onmessage request
  end

  def onbinary(data)
    handle_binary data
  end

  def onclose event
    puts "Disconnected: #{event}"
    binary_temp_clean    
  end

  def onerror(reason)
    puts "onerror: #{reason}"
  end

  def self.init(ws)
    ws.onopen    { |hs| MiddleWare.new(ws).onopen hs }
    ws.onmessage { |msg| MiddleWare.new(ws).onmessage JSON.parse(msg,{:symbolize_names => true}) }
    ws.onclose   { |event| MiddleWare.new(ws).onclose event }
    ws.onbinary  { |data| MiddleWare.new(ws).onbinary data } 
#    ws.onerror   { |reason| MiddleWare.new(ws).onerror reason }
  end

end

