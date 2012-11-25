module JSONHelper

  def get_response
    ActiveSupport::JSON.decode(response.body).with_indifferent_access
  end
end


