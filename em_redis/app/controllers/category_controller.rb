# encoding: utf-8

class Category < EMWSFW::ControllerBase

  def list
    {
      :data    => DBWork.load_cats,
      :caption => "Категории"
    }
  end

  def detail
    {
        :name => $DB.get("cat:#{@data[:id]}:name")
    }
  end

end
