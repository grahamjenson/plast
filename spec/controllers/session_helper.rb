module SessionHelper

  def set_session(session_id)
    session = Session.where(:session_id => session_id).first
    if not session
      session = Session.create(:session_id => session_id)
    end
    if @controller
      @controller.request.session_options[:id] = session_id
    end
    return session
  end
end
