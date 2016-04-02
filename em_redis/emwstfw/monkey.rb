# encoding: utf-8

class EventMachine::WebSocket::Connection
  def userData
     @userData ||=
     {
       :user        => UserAccount.new,
       :mutex       => Mutex.new,
       :binary_data =>
       {
         :list      => [],
         :corrent   => nil
       },
       :binary_temp => [],
       :oauth_provider=> {}
     }
     return @userData
  end
end

class UserAccount
  attr_accessor :id

  def initialize
    @id = 2
    info 'init'
  end

  def info m
    puts "#{m} user: #{id}"
  end

end
