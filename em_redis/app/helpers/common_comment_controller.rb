
class CommonCommentController < EMWSFW::ControllerBase

  def self.config(item_name, create_method, list_method)
    @item_name = item_name.to_sym
    @create_method = create_method.to_sym
    @list_method = list_method.to_sym
  end

  #item,load_comments
  def list_by_item
    get_list "#{item_name}:#{@data[:arg]}:comments"
  end

  def list_by_item_new
    get_list_new "#{item_name}:#{@data[:arg]}:comments"
  end

  def post
    {
        :id => DBWork.send(create_method, @data[:id],@user.id,@data[:text])
    }
  end

  private

  def item_name;     self.class.instance_variable_get '@item_name';     end
  def create_method; self.class.instance_variable_get '@create_method'; end
  def list_method;   self.class.instance_variable_get '@list_method';  end

  def get_list(item_id)
    @data[:nextbase] ||= 0
    result = DBWork.get_raw_page item_id, @data[:nextbase]
    result[:data] = DBWork.send list_method, result[:data]
    result
  end

  def get_list_new(item_id)
    @data[:tcount] ||= 0
    result = DBWork.get_raw_new_items item_id, @data[:tcount]
    result[:data] = DBWork.send list_method, result[:data]
    result
  end

end
