# encoding: utf-8
module EMWSFW
  module Request

    def handle_onmessage (request)
      if request_valid? request
        unless deffered? request
          handle_and_post request
        end
      else
        post Hash[:error => @last_error], request
      end
    end

    def handle_and_post (request)
      post handle_request(request), request
    end

    def handle_request request
      responce = nil
      responce = action_single request                     if request.has_key? :action
      responce ||= {}
      handle_request_multipart_section   request, responce unless responce.has_key? :error
      handle_request_multipart_n_section request, responce unless responce.has_key? :error
      responce[:handler] = request[:handler]               if request.has_key? :handler
      responce
    end

    def handle_request_multipart_section(request,responce)
      if request.has_key? :multipart
        if Array === request[:multipart]
          responce[:multipart] = request[:multipart].map do |action|
            action_single action
          end
        else
          responce[:error] = 'Wrong multipart data'
        end
      end
    end

    def handle_request_multipart_n_section(request,responce)
      if request.has_key? :multipart_n
        if Hash === request[:multipart_n]
          responce[:multipart_n] = {}
          request[:multipart_n].each do |key, value|
            responce[:multipart_n][key] = action_single value
          end
        else
          responce[:error] = 'Wrong multipart_n data'
        end
      end
    end

    def request_valid? request
      if Hash === request
        if (request.keys & [:multipart,:multipart_n,:action]).any?
          return true  
        else
          @last_error = 'wrong request: unknown what to do'
        end
      else
        @last_error = 'wrong request'
      end
      false
    end

  end
end
