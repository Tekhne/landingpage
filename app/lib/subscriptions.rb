class Subscriptions
  include LogsAndRaisesExceptions

  class Error < StandardError
    attr_accessor :original_exception
  end

  def subscribe(params)
    Contact.create!(email: params.fetch(:email))
  rescue ActiveRecord::RecordInvalid => exception
    log_and_raise(exception, 'The information provided was invalid.')
  rescue ActionController::ParameterMissing => exception
    log_and_raise(exception, 'No email was provided.')
  end
end
