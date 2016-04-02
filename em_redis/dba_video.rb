class DBWork

  def DBWork.create_video(name, desc, man, secret)
    if $DB.exists "user:#{man}"
      id    = $DB.incr 'seq:video'
      idkey = "video:#{id}:data"
      $DB.pipelined do
        $DB.hset idkey, 'name', name
        $DB.hset idkey, 'descr', desc
        $DB.hset idkey, 'man', man
        $DB.hset idkey, 'secret',secret
        $DB.hset idkey, 'status', 0
        $DB.zadd "user:#{man}:video", id.to_i, id
        $DB.rpush 'video:needprepare', id
        if $DB.llen('video:needprepare') ==1
          $DB.publish 'video:needprepare:received', id
        end
      end
     id
    end
  end

  def DBWork.get_video_to_prepare
    video_id = $DB.lpop 'video:needprepare'
    unless id.nil?
      vid_key = "video:#{video_id}"
      $DB.hset vid_key,'status', 1
      sec = $DB.hget vid_key,'secret'
      $DB.zadd 'video:preparing', video_id.to_i, video_id
      return [id, sec]
    end
    nil
  end  

  def DBWork.set_video_prepared(video_id)
    vid_key = "video:#{video_id}"
    if $DB.exists vid_key
      $DB.zrem 'video:preparing',video_id
      $DB.hset vid_key, 'status', 2
      $DB.zadd 'videos', video_id.to_i,video_id
    end
  end

  def DBWork.load_video(video_id, user_id)
    j       = hgetall("video:#{video_id}:data").merge! Hash[id: video_id]
    j[:man] = load_user j[:man]
    if block_given?
      j = yield j, user_id
    end
    j     
  end

  def DBWork.load_videos list_video_id, user_id, &block
    list_video_id.map { |i| load_video i, user_id ,&block}
  end

  def DBWork.create_video_comment (video_id,user_id,text)
    if $DB.exists "video:#{video_id}:data"
      if $DB.exists "user:#{user_id}"
        id = $DB.incr 'seq:video_comment'
        idd = "comment_video:#{id}"
        $DB.pipelined do
          $DB.hset idd, 'video', video_id
          $DB.hset idd, 'user', user_id
          $DB.hset idd, 'text', text
          $DB.hset idd, 'cdt', Time.new.strftime('%d.%m.%Y %H:%M:%S')
          $DB.zadd "video:#{video_id}:comments", id, id
          $DB.zadd "user:video:#{user_id}:comments", id, id
        end
        id
      end
    end 
    nil
  end

  def DBWork.load_video_comment (comment_id)
    comment = hgetall "comment_video:#{comment_id}"
    comment[:id]   = comment_id
    comment[:user] = load_user comment[:user]
    comment
  end

  def DBWork.load_video_comments list_video_comments_id
    list_video_comments_id.map { |i| load_video_comment i}
  end

end