class StaticPagesController < ApplicationController
  def home
    # render ...
    # アクション直下にレンダリングさせるファイルを指定できる
    # renderなどの指示がない場合、app/views/static_pages/home.html.erbが返される=>デフォルト
    @time = Time.current.in_time_zone('Asia/Tokyo')
  end

  def help
  end

  def about
    @hello = "This is about page mother fucker"
  end


end



