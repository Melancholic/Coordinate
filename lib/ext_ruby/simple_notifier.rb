include ExceptionLogger::ExceptionLoggable
module ExceptionNotifier
  class SimpleNotifier
    def initialize(options)
    end

    def call(exception, options={})
      # send the notification
      #LoggedException
    end
  end
end