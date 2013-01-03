require 'httparty'
require 'uri'
require 'oj'



class MainController < ApplicationController

  class RequestFailed < StandardError; end

  def index
  end

  def ytrequestproxy
    Rails.logger.debug(params)
    ytid = params[:ytid]
    url = "http://www.youtube.com/watch?v=#{ytid}"

    #args = ["--get-url", url]
    #dlurl = `python #{File.expand_path(File.dirname(__FILE__))}/youtube-dl.py #{args.join(" ")}`

    #download_url = "http://www.youtube.com/get_video?video_id={0}&t={1}&fmt=18".format(
    #    video_id, token_value)

    info = convert(url)

    ytdlurl = "http://www.youtube-mp3.org/get?video_id=#{params[:ytid]}&h=#{info['h']}&r=#{Time.now.to_i}"
    dlurl = `curl "#{ytdlurl}" -L --max-filesize 100 -o /dev/null -w '%{url_effective}'`

    render json: {dlurl: dlurl}
  end


  def convert(url)
    r = HTTParty.get("http://www.youtube-mp3.org/api/pushItem/?item=#{CGI.escape(url)}&xy=yx&bf=false&r=#{Time.now.to_i}", :headers => {"Accept-Location" => "*"})

    handle_error(r)

    video_id = r

    3.times do
      r = HTTParty.get "http://www.youtube-mp3.org/api/itemInfo/?video_id=#{video_id}&ac=www&r=#{Time.now.to_i}", :headers => {"Accept-Location" => "*"}
      Rails.logger.debug(r)
      handle_error(r)
      info = Oj.load(r.match(/\Ainfo = (.*?);\z/)[1])

      if info["status"] == "serving"
        @downloadable = "http://www.youtube-mp3.org/get?video_id=#{video_id}&h=#{info['h']}&r=#{Time.now.to_i}"
        @title = info["title"]
        return  info
      end

      sleep 1
    end
    raise RequestFailed, "youtube-mp3 not working fast enough"
  end

  def handle_error( body )
    case body
      when "$$$LIMIT$$$" then raise RequestFailed, "YouTubeMP3 limit reached! Only 15 convertions per 30 minutes."
      when "$$$ERROR$$$" then raise RequestFailed, "There was an Error caused by YouTube, we cannot deliver this Video! This error is mostly caused by copyright issues or the length of the video. YouTubeMP3 only support videos with maximum of 20 minutes."
    end
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
