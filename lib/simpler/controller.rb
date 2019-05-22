require './lib/simpler/view'

module Simpler
  class Controller
    
    attr_reader :name

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.handler'] = "#{self.class.name}##{action}"
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['simpler.template'] = "#{[self.name, action].join('/')}.html.erb"
      
      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    def params
      @params ||= @request.params.dup
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def set_response_headers(headers = {})
      @response.headers.merge!(headers)
    end

    def set_response_status=(status)
      @response.status = status
    end
    
    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding) if @response.content_type.eql?('text/html')
    end

    def render(string_or_hash)
      if string_or_hash.is_a?(Hash)
        if string_or_hash.keys.include?(:plain)
          set_response_headers('Content-Type' => 'text/plain') 
          @response.write(string_or_hash[:plain])
        end
      else
        @request.env['simpler.template'] = "#{string_or_hash}.html.erb"
      end
    end

  end
end
