require 'fileutils'

class Video < EMWSFW::ControllerBase


  def add
    unless valid_file_field? :video
      return @lasterror
    end
    cf = @data[:video].first
    unless valid_file? cf, :video
      return @lasterror
    end

    id = DBWork.create_video @data[:name], @data[:description], @user.id, cf[:id]
    @middleware.binary_remove_from_temp cf[:temp_path]
    vfn = "#{id},#{cf[:id]}"
    queue = "./queue/#{vfn}"
    FileUtils.mv cf[:temp_path], queue
    movie = FFMPEG::Movie.new(queue)
    movie.screenshot("../public/item_pic/l#{vfn}.png", { seek_time: 2, resolution: '80x64'   }, preserve_aspect_ratio: :height)
    movie.screenshot("../public/item_pic/d#{vfn}.png", { seek_time: 2, resolution: '512x385' }, preserve_aspect_ratio: :width)
    {
        :new_id => id
    }
  end

  def details
    {
        :data => DBWork.load_video(@data[:id],@user.id)
    }
  end

  def list_video
    get_list 'videos'
  end

  def list_prepvideo
    get_list 'video:preparing'
  end

  def list_myvideo
    get_list "user:#{@user.id}:video"
  end

  private

  def get_list(list_id, &per_item)
    @data[:nextbase] ||= 0
    result = DBWork.get_raw_page list_id, @data[:nextbase]
    result[:data] = DBWork.load_videos result[:data], @user.id, &per_item
    result
  end

end
