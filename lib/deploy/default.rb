module Deploy
  module Default
    def self.included(klass)
      klass.extend(ClassMethods)

      # make the static methods reachable by instances
      klass.class_eval do
        define_method :default, &klass.method(:default)
        define_method :defaults, &klass.method(:defaults)
      end
    end

    module ClassMethods
      def default(key, value = nil, &block)
        @default_options ||= Hash.new
        @default_options[key] = value || block
      end

      def defaults(options)
        options = options.dup

        @default_options ||= Hash.new
        @default_options.each do |key, value|
          if value.is_a?(Proc)
            options[key] ||= value.call(options)
          else
            options[key] ||= value
          end
        end

        options
      end
    end
  end
end
