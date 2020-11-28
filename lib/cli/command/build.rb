module CLI
  class Command
    class Build < Command
      require_relative '../info'
      require_relative '../utils'
      require_relative '../ui'

      @description = "Builds apps Swift, Xibs and Storyboard files.\
      \nConfigurate Info.plist file for app bundle."

      attr_reader :verbose, :proj_name, :proj_path

      def self.description()
        @description
      end

      def run(options)
        @verbose = options[:verbose]
        @proj_name = Info.user_selected_project_name
        @proj_path = Info.user_selected_project_path

        UI.log "Build app #{@proj_name}...", 'blue'

#        self.clear_temp
#        self.prepare_bundle
#        self.build_swift_files
#        self.build_xibs_and_storyboards
        self.generate_plist
#        self.handle_resources

        UI.log 'Build done.', 'blue'
      end

      def clear_temp()
        UI.log 'Cleanning build temp folder.', 'light_blue' if @verbose
        Utils.clear_dir Info.user_temp, @verbose
      end

      def prepare_bundle()
        UI.log 'Preparing bundle.', 'light_blue' if @verbose
        Dir.mkdir "#{Info.user_builds}/#{@proj_name}.app" unless File.exists? "#{Info.user_builds}/#{@proj_name}.app"
        Utils.clear_dir "#{Info.user_builds}/#{@proj_name}.app", @verbose
      end

      def build_swift_files()
        UI.log 'Compile Swift files: ', 'light_blue' if @verbose
        swiftc_base = "swiftc $(find #{@proj_path} -type f -name '*.swift')"
        sdk = "-sdk $(xcrun --sdk iphonesimulator --show-sdk-path)"
        target = "-target x86_64-apple-ios13.0-simulator"
        emit_executable = "-emit-executable -o #{Info.user_builds_full}/#{@proj_name}.app/#{@proj_name}"
        Utils.sh "#{swiftc_base} #{sdk} #{target} #{emit_executable}", @verbose
      end

      def build_xibs_and_storyboards()
        UI.log 'Compile Xib files.', 'light_blue' if @verbose
        ibtool = "/usr/bin/ibtool $e --compilation-directory #{Info.user_builds_full}/#{@proj_name}.app/#{@proj_name}"
        Utils.sh "for e in $(find #{@proj_path} -type f -name '*.storyboard'); do #{ibtool}; done", @verbose
        Utils.sh "for e in $(find #{@proj_path} -type f -name '*.xib'); do #{ibtool}; done", @verbose
      end

      def generate_plist()
        UI.log 'Parsing plist file', 'light_blue' if @verbose
        Utils.sh "cp #{@proj_path}/#{@proj_name}/Info.plist #{Info.user_temp_full}/Info.plist", @verbose
      end

      def handle_resources()
        UI.log 'Copy resources', 'light_blue' if @verbose
      end

      private :clear_temp,
        :build_swift_files,
        :build_xibs_and_storyboards,
        :generate_plist,
        :handle_resources
    end
  end
end
