module LogsAndRaisesExceptions
  private

  def log_and_raise(exception, message, options = {})
    location = exception.backtrace.grep(/#{Rails.root}/).first
    error = "ERROR: #{exception.class}: #{location}: #{message}"

    if exception.is_a?(ActiveRecord::RecordInvalid)
      error = "#{error} (errors hash: #{exception.record.errors.to_hash})"
    end

    Rails.logger.error error

    if options[:klass]
      new_exception = options[:klass].new(message)
    elsif defined?(self.class::Error)
      new_exception = self.class::Error.new(message)
    else
      return
    end

    if new_exception.respond_to?(:original_exception=)
      new_exception.original_exception = exception
    end

    raise new_exception
  end
end
