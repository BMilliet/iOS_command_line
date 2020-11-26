module CLI
  class Command
    class Launch < Command
      attr_reader :verbose 

      def self.description()
        'Can launch latest build and simulators.'
      end

      def run(options)
        @verbose = options[:verbose]
      end
    end
  end
end
