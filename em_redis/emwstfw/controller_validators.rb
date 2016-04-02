
module EMWSFW
  module ControllerValidators

    def validate_image_field (field_name,&on_ok)
      if @data.has_key? field_name
        unless @data[field_name].match(/^data\:image\/png\;base64\,/).nil?
          if block_given?
            yield
          end
        else
          {
            :error => "wrong data format of field #{field_name}"
          }
        end
      else
        {
          :error => "expected field #{field_name}"
        }
      end
    end

    def valid_file_field?(file_field)
      unless @data.has_key? file_field
        @last_error = "no #{file_field} field"
        return false
      end
      unless Array === @data[file_field]
        @last_error = "#{file_field} field wrong type"
        return false
      end
      return true
    end

    def valid_file? (file_data, name)
      unless Hash === file_data
        @last_error = "file '#{name}' field wrong type"
        return false
      end
      unless file_data.has_key? :status
        @last_error = "file '#{name}' field no status"
        return false
      end
      unless file_data[:status] == EMWSFW::Binary::STATUS_DONE
        @last_error = "file '#{name}' field wrong file status"
        return false
      end
      unless file_data.has_key? :temp_path
        @last_error = "file '#{name}' field no temp path"
        return false
      end
      return true
    end


  end
end