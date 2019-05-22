module Simpler
  class Router
    class Route
      attr_reader :controller, :action, :params

      REGEX_PATHS = [ 
        %r{\A\/\w+\/?\Z},                               # path like /tests | /tests/
        %r{\A\/\w+(?:\/?\Z|\/([^\/;.,?]+)\/?)\Z},       # path like /tests/:id | /tests/:id/
        %r{\A\/\w+(?:\/?\Z|\/([^\/;.,?]+)\/edit\/?)\Z}  # path like /tests/:id/edit | /tests/:id/edit/
      ] 

      def initialize(method, path, controller, action)
        @method = method
        @path = path 
        @controller = controller
        @action = action
        @params = {}
        @regex = REGEX_PATHS.detect {|regex| path.match?(regex)} 
      end

      def match?(method, path)
        @method == method && path.match(@regex)
      end

      def recognize_path(method, path)
        if @method == method && match = path.match(@regex) 
          @params[:id] = match[1]
          return true 
        end
        false
      end
    end
  end
end
