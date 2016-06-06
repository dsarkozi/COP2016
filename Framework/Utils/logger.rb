require 'logger'

module Logging
	def logger
		@logger ||= Logging.logger_for(self.class.name, STDOUT)
	end
	def loggerr
		@loggerr ||= Logging.logger_for(self.class.name, STDERR)
	end
	@loggers = {}
	
	class << self
		def logger_for(classname, out)
			@loggers[classname] ||= configure_logger_for(classname, out)
		end
		
		def configure_logger_for(classname, out)
			file = File.open('foo.log', File::WRONLY | File::APPEND | File::CREAT)
			logger = Logger.new MultiIO.new(out, file)
			logger.progname = classname
			logger.datetime_format = '%Y-%m-%d %H:%M:%S'
			logger
		end
	end
	
	class MultiIO
		def initialize(*targets)
			@targets = targets
		end
		
		def write(*args)
			@targets.each {|t| t.write(*args)}
		end
		
		def close
			@targets.each(&:close)
		end
	end
end