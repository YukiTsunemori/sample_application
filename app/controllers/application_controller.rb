class ApplicationController < ActionController::Base
  def hello
    render html: "What`s up buddy"
  end
end
