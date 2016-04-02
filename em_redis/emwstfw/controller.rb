# encoding: utf-8

module EMWSFW

  module ControllerFlag
    def initialize(data,ws,mw)
      @data = data
      @session = ws.userData
      @middleware = mw
      @user = @session[:user]
    end
  end

  class ControllerBase
    include ControllerFlag
    include ControllerValidators

  end

end
