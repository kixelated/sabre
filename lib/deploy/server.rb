module Deploy
  module Server
    def self.included(klass)
      klass.extend(ClassMethods)

      # make the static methods reachable by instances
      klass.class_eval do
        define_method :server, &klass.method(:server)
        define_method :servers, &klass.method(:servers)
      end
    end

    module ClassMethods
      def server(host, *roles)
        @servers ||= Array.new
        @servers << host

        @servers_lookup ||= Hash.new
        @servers_lookup[roles] ||= Array.new
        @servers_lookup[roles] << host
      end

      def servers(*roles)
        @servers_lookup ||= Hash.new
        @servers_lookup[roles] || Array.new
      end
    end
  end
end
