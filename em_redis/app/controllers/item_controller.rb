

class Item  < EMWSFW::ControllerBase

  @image_path      = '../public/item_pic/'
  @image_extension = '.png'

  def list_by_cat_paid
    get_list "cat:#{@data[:arg]}:items_paid"
  end

  def list_by_cat_free
    get_list "cat:#{@data[:arg]}:items_free"
  end

  def list_by_cat_load
    get_list "cat:#{@data[:arg]}:items_load"
  end

  def list_my_loads
    get_list "user:#{@user}:loads"
  end

  def list_my_approve
    get_list "user:#{@user.id}:items"
  end

  def list_my_needapprove
    get_list "user:#{@user.id}:needapprove"
  end

  def list_requests
    get_list 'item:needapprove'
  end

  def list_my_votes
    get_list "user:#{@user.id}:votes" do |i,u|
      i[:myvote] = DBWork.load_user_item_vote(i[:id], u)
      i
    end
  end

  def list_search
    @data[:nextbase] ||=0
    d = DBWork.get_search_page @data[:arg], @data[:nextbase]
    d[:data] = DBWork.load_items d[:data], @user.id
    d
  end

  def details
    {
        :data => DBWork.load_item(@data[:id], @user.id, true) do |i,u|
          i[:myvote]   = DBWork.load_user_item_vote(i[:id], u).to_i
          i[:approved] = DBWork.item_approved? i[:id]
          i[:cat_name] = if i[:approved]
                           ( DBWork.get_cat_name i[:cat])
                         else
                           ''
                         end
          i
        end
    }
  end

  def approve
    {
      :approved => DBWork.item_approve(@data[:id])
    }
  end

  def vote
    {
        :vote => DBWork.item_vote(@data[:id], @user.id, @data[:val])
    }
  end

  def add
    validate_image_field :picture512 do
      validate_image_field :picture64 do
        new_id = DBWork.create_item @data[:name], @data[:description], @data[:category], @user.id, @data[:cost]
        save_image_field_to_file :picture512, "d#{new_id}"
        save_image_field_to_file :picture64, "l#{new_id}"
        {
            :new_id => new_id
        }
      end
    end
  end

  def load
    {
        :loads => DBWork.item_load(@data[:id], @user.id)
    }
  end

  private

  def get_list(list_id ,&cl)
    @data[:nextbase] ||=0
    d = DBWork.get_raw_page list_id, @data[:nextbase]
    d[:data] = DBWork.load_items d[:data], @user.id, &cl
    d
  end



  def save_image_field_to_file field_name, filename
    data = @data[field_name].sub('data:image/png;base64,','').unpack("m").first
    File.write "#{@image_path}#{filename}#{@image_extension}",data
  end

end


