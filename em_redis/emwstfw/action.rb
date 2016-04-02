# encoding: utf-8

module EMWSFW
  module Action

    def action_single (request)
      if Hash === request
        if request.has_key? :action
          action_data = get_Action(request[:action].to_s)
          unless action_data.nil?
            begin
              controller_instance = action_data[:controller].new(request,@ws,self)
              responce = controller_instance.send action_data[:method]
              responce = { :result => responce } unless  Hash === responce
              responce
          #  rescue Exception => e ;{ :error => 'Exception:'+e.to_s            }; 
            end
          else                     { :error => "unknown action:#{request[:action]}"}; end
        else                       { :error => "no action param"                }; end
      else                         { :error => "wrong request"                  }; end
    end

    def get_Action(action)
      action_parts = action.split('.')
      action_class = nil
      if action_parts.length == 2
        action_parts[0].split('::').inject(Object) do |mod, class_name|
          action_class = mod.const_get(class_name)
        end 
        unless action_class.nil?
          if action_class.ancestors.include? ControllerFlag
           action_method = action_parts[1].to_sym
            if action_class.instance_methods.include? action_method
              return {
                  :controller => action_class,
                  :method     => action_method
              }
            end
          end
        end
      end
      nil
    end

  end

end
