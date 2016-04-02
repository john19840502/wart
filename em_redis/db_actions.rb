# encoding: utf-8

class DBWork
  PAGE_SIZE = 2

  def DBWork.create_cat(name)
    id = $DB.incr 'seq:cat'
    $DB.set "cat:#{id}:name", name
    id
  end

  def DBWork.load_cats
    $DB.keys('cat:*:name').map do |n|
      {:id   => n[ /\:(.*)\:/,1],
       :name => $DB.get(n)
      }
    end
  end

  def DBWork.create_item(name, description, category, owner_id, cost)
    if $DB.exists "cat:#{category}:name"
      if $DB.exists "user:#{owner_id}"
        id = $DB.incr 'seq:item'
        idd = "item:#{id}:data"
        $DB.pipelined do
          $DB.hset idd, 'name', name
          $DB.hset idd, 'descr', description
          $DB.hset idd, 'cat', category
          $DB.hset idd, 'man', owner_id
          $DB.hset idd, 'cost', cost
          $DB.hset idd, 'loads', 0
          $DB.hset idd, 'vote1', 0
          $DB.hset idd, 'vote2', 0
          $DB.hset idd, 'vote3', 0
          $DB.hset idd, 'vote4', 0
          $DB.hset idd, 'vote5', 0
          $DB.hset idd, 'vote', 0
          $DB.zadd 'item:needapprove', id.to_i, id
          $DB.zadd "user:#{owner_id}:needapprove", id.to_i, id
        end
        id
      end
    end
  end

  def DBWork.item_approve(item_id)
    if $DB.exists "item:#{item_id}:data"
      unless $DB.zrank('item:needapprove', item_id).nil?
        cat, man, cost, name = $DB.hmget "item:#{item_id}:data", :cat,:man,:cost,:name
        #man = $DB.hget "item:#{item_id}:data", :man
        $DB.zrem 'item:needapprove', item_id
        $DB.zrem "user:#{man}:needapprove", item_id
        $DB.zadd "cat:#{cat}:items", item_id.to_i, item_id
        if cost.nil? || cost.to_i == 0
          $DB.zadd "cat:#{cat}:items_free", 0, item_id
        else
          $DB.zadd "cat:#{cat}:items_paid", 0, item_id
        end
        $DB.zadd "cat:#{cat}:items_load", 0, item_id
        $DB.zadd "user:#{man}:items", item_id.to_i, item_id
        escname = $DBs.escape(name)
        $DBs.query "insert into items values(#{item_id},'#{escname}')"
        return true
      end
    end
    false
  end

  def DBWork.item_vote(item_id,user_id,votelvl)
    votelvl = votelvl.to_i
    if votelvl > 0 && votelvl < 6
      hid="item:#{item_id}:data"
      if $DB.exists hid
        if $DB.exists "user:#{user_id}"
          unless $DB.zscore "user:#{user_id}:votes", item_id
            $DB.hincrby hid,"vote#{votelvl}", 1
            v1, v2, v3, v4, v5, cat= $DB.hmget(hid, :vote1, :vote2, :vote3, :vote4, :vote5,:cat).map{|i|i.to_i}
            v = ((v1 + v2 * 2 + v3 * 3 + v4 * 4 +v5 * 5 ) * 100 / (v1+v2+v3+v4+v5)).to_i/100
            $DB.hset hid, :vote, v
            $DB.zadd "user:#{user_id}:votes", votelvl, item_id
            v
          end
        end
      end
    end
  end

  def DBWork.item_load(item_id, user_id)
    if $DB.exists "item:#{item_id}:data"
      if $DB.exists "user:#{user_id}"
        unless $DB.zscore "user:#{user_id}:loads", item_id
          iid="item:#{item_id}:data"
          nload = $DB.hincrby iid,'loads', 1
          cat   = $DB.hget iid, :cat
          $DB.zadd "cat:#{cat}:items_load", nload, item_id
          $DB.zadd "user:#{user_id}:loads", item_id, item_id
          nload
        end
      end
    end
  end

  def DBWork.create_comment (item_id, user_id, text)
    if $DB.exists "item:#{item_id}:data"
      if $DB.exists "user:#{user_id}"
        id = $DB.incr 'seq:comment'
        idd = "comment:#{id}"
        $DB.pipelined do
          $DB.hset idd,'item', item_id
          $DB.hset idd,'user', user_id
          $DB.hset idd,'text', text
          $DB.hset idd,'cdt', Time.new.strftime('%d.%m.%Y %H:%M:%S')
          $DB.zadd "item:#{item_id}:comments", id, id
          $DB.zadd "user:#{user_id}:comments", id, id
        end
        id
      end
    end
  end

  def DBWork.create_user(login, name)
    id = $DB.zscore 'users', login
    if id.nil?
      id = $DB.incr 'seq:user'
      $DB.zadd 'users', id, login
      idd = "user:#{id}"
      $DB.hset idd, 'login', name
      $DB.hset idd,'name', name
    end
    id
  end

  def DBWork.delete_cat (cat_id)
  
  end

  def DBWork.delete_item (item_id)
  
  end

  def DBWork.delete_comment (comm_id)
  
  end

  def DBWork.delete_user (user_id)
    
  end

  def DBWork.get_raw_page (list_id, base = 0, prevcount = 0)
    loadcount = count = $DB.zcard list_id
    r = {
         :havemore => false,
         :tcount   => count
    }
    if prevcount > 0
      if count > prevcount
        base = base + (count - prevcount)
      end
    end
    if count - base > PAGE_SIZE
      loadcount = PAGE_SIZE
      r[:havemore] = true
      r[:nextbase] = base + loadcount
    end
    r[:data] = $DB.zrevrange list_id, base, base + loadcount - 1
    r
  end

  def DBWork.get_search_page(searchtext, base = 0)
    r = []
    text = $DBs.escape(searchtext)
  
    sql = "SELECT id FROM items WHERE MATCH (caption) AGAINST ('#{text}') limit #{base}, #{PAGE_SIZE}"
    $DBs.query(sql).each do |row|
      r << row[:id]
    end
    {
      :data     => r,
      :nextbase => base + r.length,
      :havemore => r.length == PAGE_SIZE
    }
  end

  def DBWork.get_raw_new_items(list_id, prevcount)
    count = $DB.zcard list_id
    r = { :tcount => count,
          :data   => []
    }
    loadcount = count - prevcount
    if loadcount > 0
      if loadcount > PAGE_SIZE
        loadcount = PAGE_SIZE
      end
      r[:data] = $DB.zrevrange list_id, 0, loadcount - 1
    end
    r
  end

  def DBWork.hgetall hash_key
    $DB.hgetall(hash_key).map do |key, value|
      {
          key.to_sym => value
      }
    end.reduce({}, :merge)
  end

  def DBWork.load_user (user_id)
    hgetall( "user:#{user_id}").merge!({:id => user_id})
  end

  def DBWork.load_item (item_id, user_id, extend = false)
    j = {
      :id => item_id
    }
    if extend
      j.merge! hgetall("item:#{item_id}:data")
      for i in 1..5 do
        j["vote#{i}".to_sym] = j["vote#{i}".to_sym].to_i
      end
      j[:vote] = j[:vote ].to_f
      j[:man] = load_user j[:man]
    else
      a = [:name,:man,:cost,:vote,:loads]
      j.merge!  Hash[a.zip($DB.hmget("item:#{item_id}:data",a))]
      j[:man_name] = $DB.hget("user:#{j[:man]}", :name)
    end
    j[:loaded] = $DB.zscore("user:#{user_id}:loads", item_id ).nil? ? false:true
    if block_given?
      j = yield j,user_id
    end
    j
  end

  def DBWork.item_approved?(item_id)
    $DB.zscore('item:needapprove', item_id).nil? ? true : false
  end

  def DBWork.get_cat_name (catalog_id)
    $DB.get "cat:#{catalog_id}:name"
  end


  def DBWork.load_user_item_vote(item_id, user_id)
    r = $DB.zscore "user:#{user_id}:votes", item_id
    r ||= 0
  end

  def DBWork.load_items(list, user_id, extend = false, &block)
    list.map { |i| load_item i, user_id ,extend, &block }
  end

  def DBWork.load_comment(comment_id)
    j = hgetall "comment:#{comment_id}"
    j[:id] = comment_id
    j[:user] = load_user j[:user]
    j
  end

  def DBWork.load_comments(list_comments_id)
    list_comments_id.map { |i| load_comment i}
  end
end
