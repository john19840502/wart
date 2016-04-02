# encoding: utf-8

require 'thread'
#mutex = Mutex.new
$temp_dir="./tmp/"

module EMWSFW

  module Binary
    STATUS_INQUEUE = 0
    STATUS_WORKING = 1
    STATUS_DONE    = 2
    STATUS_ERROR   = 3
    STATUS_ABORT   = 4
    SLICE_SIZE     = 1024 * 1024.0

    def has_binary?(request)
      if request.has_key? :binary
        if Array === request[:binary]
          fn=[:id,:param_name,:name,:type,:size]
          if request[:binary].select {|i| ( Hash === i) &&
                                      (i.keys & fn).length == fn.length
                                  }.size == request[:binary].size  # test all need to start upload
            push_binary request
            return true
          end
        end
        responce = { :error =>'wrong request:binary: error format description' }
        post responce,request
        return true
      end
      false
    end

    def work_with_binary
      @ws.userData[:mutex].synchronize do
        if block_given?
          yield @ws.userData[:binary_data]
        end
      end
    end

    def push_binary (request)
      request[:binary].each do |binary|
        binary[:status]= STATUS_INQUEUE
      end
      work_with_binary do |binaries|
        if binaries[:current].nil?
          binaries[:current]=request
          binary_handle_stack
        else
          binaries[:list].push(request)
        end
      end
    end

    def binary_handle_stack
       binary_data = @ws.userData[:binary_data]
       unless binary_data[:current].nil?
         binary_handle_stack_current binary_data[:current]
       else
         binary_data[:current] = binary_data[:list].shift
         unless binary_data[:current].nil?
           binary_handle_stack
         end 
       end
    end

    def gen_temp_path (binary_id)
      "#{$temp_dir}#{binary_id}"
    end

    def binary_ready_handle request
      puts 'binary_ready_handle'
      request[:binary].each do |binary|
         param_name = binary.delete(:param_name).to_sym
         binary.delete :slcount
         binary.delete :rslices
         request[param_name] ||= []
         request[param_name].push binary
      end
      request.delete :binary
      handle_onmessage request #bunary handled repush to request handling pipe
    end

    def binary_temp_clean
      @ws.userData[:binary_temp].each do |path|
        begin
          File.delete path
        rescue Exception => e
          puts "Error on delete temp file(#{path}): #{e}"
        end
      end
    end

    def binary_remove_from_temp(path)
      @ws.userData[:binary_temp].delete path
    end

    def binary_handle_stack_current(current_request)
      current_binary = current_request[:binary].select {|i| i[:status] == STATUS_WORKING }.first
      if current_binary.nil?
        current_binary = current_request[:binary].select {|i| i[:status] == STATUS_INQUEUE }.first
        unless current_binary.nil?
          current_binary[:status] = STATUS_WORKING
          binary_post_datarequest current_binary[:id]
        else
          binary_ready_handle current_request
          @ws.userData[:binary_data][:current] = nil
          binary_handle_stack
        end
      else
#        puts 'WTF? 0_o'
      end
    end

    def binary_post_datarequest(binary_id, slice_index = 0)
      post Hash[
            :handler => 'Binary.Transmitter.getSlice',
            :id      => binary_id,
            :snum    => slice_index
      ]
    end

    def binary_post_done (binary_id)
      post Hash[
        :handler => 'Binary.Transmitter.done',
        :id      => binary_id
      ]
    end

    def binary_store(binary,data)
      unless binary.has_key? :temp_path
        binary[:temp_path] = gen_temp_path binary[:id]
        binary[:slice_count] = (binary[:size]/SLICE_SIZE).ceil
        binary[:ready_slices] = 0
        @ws.userData[:binary_temp].push binary[:temp_path]
      end
      s = binary[:ready_slices] * SLICE_SIZE
      e = [(binary[:ready_slices] + 1) * SLICE_SIZE,binary[:size]].min
      corsz=e-s
      unless corsz==data.length
        puts "Wrong slice size #{corsz}!=#{data.length}"
        return
      end
      File.open(binary[:temp_path],'ab') do |file|
        file.write data
      end
      binary[:ready_slices]+=1

      
      if binary[:ready_slices]<binary[:slice_count]
        binary_post_datarequest binary[:id], binary[:ready_slices]
      else
        binary[:status]=STATUS_DONE
        binary_post_done binary[:id]
      end
    end

    def handle_binary  external_data    #call when external binary data received
      work_with_binary do |binaries|
        r={}
        unless binaries[:current].nil?
          current=binaries[:current][:binary].select {|i| i[:status]==STATUS_WORKING }.first
          unless current.nil?
            binary_store current,external_data
            binary_handle_stack
          else
            r[:error]='receive binary data, but receiver in wrong state'
          end
        else
          r[:error]='receive binary data, but does not wait this.'
        end
        post r
      end      
    end
    #--------------------------------------------------------------------------
    def receive_binary_ErrorRequestId request
      work_with_binary do |binaries|
        unless binaries[:current].nil?
          current=binaries[:current][:binary].select do |binary|
            binary[:id]== request[:id]
          end.first
          unless current.nil?
            current[:status]=STATUS_ERROR
            current[:error]='Client dont know what is it'
            binary_handle_stack
          else
            puts 'on BinaryTranspode.ErrorRequestId: #2 O_o'
          end
        else
          puts 'on BinaryTranspode.ErrorRequestId: O_o'        
        end
      end
      {}
    end
    #--------------------------------------------------------------------------
    def receive_binary_AbortPartRequest data  #bin_id
      work_with_binary do |binaries|
        unless binaries[:current].nil?
          binaries[:current]
          
        end
      end
    end
    #--------------------------------------------------------------------------
    def receive_binary_AbortRequest request  #:req_handler
      work_with_binary do |binaries|
        unless binaries[:current].nil?
          if binaries[:current].has_key? :handler && binaries[:current][:handler]==request[:req_handler]
            binaries[:current]=nil
            binary_handle_stack
          else
            binaries[:list].reject! do |binary|
              binary[:current].has_key? :handler && binary[:current][:handler]==request[:req_handler]
            end
          end
        end
      end
      "Ok"
    end
    #--------------------------------------------------------------------------
  end
  #============================================================================
end
#==============================================================================
class BinaryTranspoder < EMWSFW::ControllerBase
  def ErrorRequestId
    @middleware.receive_binary_ErrorRequestId @data
  end
  def AbortPartRequest
    @middleware.receive_binary_AbortPartRequest @data
  end
  def AbortRequest
    @middleware.receive_binary_AbortRequest @data
  end
end
#==============================================================================
