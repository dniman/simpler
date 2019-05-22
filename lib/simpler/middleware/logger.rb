require 'logger'

module Simpler
  class AppLogger

    def initialize(app)
      @logger = Logger.new(log_file)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)
    
      log_info(env, status, headers)
      
      [status, headers, body]
    end

    private

    def log_path
      'log/'
    end

    def log_file
      Simpler.root.join(log_path,'app.log')
    end

    def log_info(env, status, headers)
      req = Rack::Request.new(env)

      @logger.info "Request: #{req.request_method} #{req.fullpath}"
      @logger.info "Handler: #{req.env['simpler.handler']}"
      @logger.info "Parameters: #{req.params}"
      @logger.info "Response: #{status} #{Rack::Utils::HTTP_STATUS_CODES[status]} [#{headers['Content-Type']}] #{req.env['simpler.template']}\n"
    end
  end
end
