class MainController < ApplicationController

  def index
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
