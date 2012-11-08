class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :get_update_session

  def get_update_session
    sid = request.session_options[:id]
    @session = Session.where(:session_id => sid).first
    logger.debug "SESSION #{@session}"
  end

end
