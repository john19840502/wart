
begin
  p = File.expand_path('../', __FILE__)
  require "#{p}/action.rb"
  require "#{p}/controller_validators.rb"
  require "#{p}/controller.rb"
  require "#{p}/binary.rb"
  require "#{p}/monkey.rb"
  require "#{p}/request.rb"
  require "#{p}/responce.rb"

end


['app/helpers','app/controllers'].each do |d|
  Dir[File.expand_path("../../#{d}/*.rb", __FILE__)].each do |i|
    require i
  end
end
