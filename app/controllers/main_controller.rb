
class MainController < ApplicationController

  class RequestFailed < StandardError; end

  def index
  end

  def ytrequestproxy
    Rails.logger.debug(params)
    ytid = params[:ytid]
    url = "http://www.youtube.com/watch?v=#{ytid}"
    args = ["--get-url", url]
    dlurl = `python #{File.expand_path(File.dirname(__FILE__))}/youtube-dl.py #{args.join(" ")}`

    render json: {dlurl: dlurl}
  end

  def faq
    render :layout => 'static'
  end

  def about
    render :layout => 'static'
  end

  def feedback
    render :layout => 'static'
  end

end
