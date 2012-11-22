module JSONHelper

  def get_response
    ActiveSupport::JSON.decode(response.body)
  end
end


