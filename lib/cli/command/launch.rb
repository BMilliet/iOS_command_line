module CLI
  class Command
    class Launch < Command
      attr_reader :verbose 

      def self.description()
        'Runs latest selected app build on booted simulator'
      end

      def run(options)
        @verbose = options[:verbose]
      end
    end
  end
end
