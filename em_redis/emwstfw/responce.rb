# encoding: utf-8

module EMWSFW
  module Responce

    def post (responce, request = nil)
      request ||= {}
      if responce.has_key? :error
        if    responce.has_key? :handler
          responce[:srcdst] = responce[:handler]
        elsif request.has_key? :handler
          responce[:srcdst] = request[:handler]
        end
        responce[:handler] = 'server_exception'
        responce[:request] = request
      end
      puts '=============================='
      puts request.to_json
      puts '------------------------------'
      puts responce.to_json
      puts '=============================='
      if responce.has_key? :handler
        @ws.send responce.to_json
      end
    end

  end
end
