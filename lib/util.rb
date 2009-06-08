# setup the logger
LOG = Logger.new(STDOUT)
class Util
  class << self
    def log_info(message)
      LOG.error("-"*80)
      LOG.info(message)
      LOG.error("-"*80)
    end

    def log_error(exception, message)
      LOG.error("-"*80)
      LOG.error("#{exception.message} -- #{message}")
      LOG.error("-"*80)
      LOG.error("#{exception.backtrace.join("\n")}")
    end
  end
end