module CLI
  class Command
    class Build < Command
      attr_reader :verbose 

      def self.description()
        'Builds apps Swift, Xibs and Storyboard files. \
        \nConfigurate Info.plist file for app bundle.'
      end

      def run(options)
        @verbose = options[:verbose]
        puts 'run command build'

        self.clear_temp
        self.build_swift_files
        self.build_xibs
        self.generate_plist
        self.handle_resources
      end

      def clear_temp()
        puts 'clear temp folder'
      end

      def build_swift_files()
        puts 'build swift files'
      end

      def build_xibs()
        puts 'build xibs'
      end

      def generate_plist()
        puts 'handle and create plist'
      end

      def handle_resources()
        puts 'handle resources'
      end

      private :clear_temp,
        :build_swift_files,
        :build_xibs,
        :generate_plist,
        :handle_resources
    end
  end
end
