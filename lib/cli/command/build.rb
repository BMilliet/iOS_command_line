module CLI
  class Command
    class Build < Command
      require_relative '../info'
      require_relative '../utils'
      require_relative '../ui'

      attr_reader :verbose, :debug, :proj_name, :proj_path, :proj_bundle_id

      def self.description()
        'Builds selected app and generate bundle.'
      end

      def run(options)
        @verbose = options[:verbose]
        @debug = options[:debug]
        @proj_name = Info.user_selected_project_name
        @proj_path = Info.user_selected_project_path
        @proj_bundle_id = Info.user_selected_project_bundle_id

        UI.log "Build app #{@proj_name}...", 'blue'

        self.clear_temp
        self.prepare_bundle
        self.build_swift_files
        self.build_xibs_and_storyboards
        self.generate_plist
        self.handle_resources

        UI.log 'Build done.', 'blue'
      end

      def clear_temp()
        UI.log 'Cleanning build temp folder.', 'light_blue' if @verbose
        Utils.clear_dir Info.user_temp, @verbose, @debug
      end

      def prepare_bundle()
        UI.log 'Preparing bundle.', 'light_blue' if @verbose
        Dir.mkdir "#{Info.user_builds}/#{@proj_name}.app" unless File.exists? "#{Info.user_builds}/#{@proj_name}.app"
        Utils.clear_dir "#{Info.user_builds}/#{@proj_name}.app", @verbose, @debug
      end

      def build_swift_files()
        UI.log 'Compile Swift files: ', 'light_blue' if @verbose
        swiftc_base = "swiftc $(find #{@proj_path} -type f -name '*.swift')"
        sdk = "-sdk $(xcrun --sdk iphonesimulator --show-sdk-path)"
        target = "-target x86_64-apple-ios13.0-simulator"
        emit_executable = "-emit-executable -o #{Info.user_builds_full}/#{@proj_name}.app/#{@proj_name}"
        Utils.sh "#{swiftc_base} #{sdk} #{target} #{emit_executable}", @verbose, @debug
      end

      def build_xibs_and_storyboards()
        UI.log 'Compile Xib files.', 'light_blue' if @verbose
        ibtool = "ibtool $e --compilation-directory #{Info.user_builds_full}/#{@proj_name}.app/Base.lproj"
        Utils.sh "for e in $(find #{@proj_path} -type f -name '*.storyboard'); do #{ibtool}; done", @verbose, @debug
        Utils.sh "for e in $(find #{@proj_path} -type f -name '*.xib'); do #{ibtool}; done", @verbose, @debug
      end

      def generate_plist()
        UI.log 'Parsing plist file', 'light_blue' if @verbose
        Utils.sh "cp #{@proj_path}/#{@proj_name}/Info.plist #{Info.user_temp_full}/Info.plist", @verbose, @debug
        plist_buddy = '/usr/libexec/PlistBuddy'
        set_CFBundleExecutable = "Set :CFBundleExecutable #{@proj_name}"
        set_CFBundleIdentifier = "Set :CFBundleIdentifier #{@proj_bundle_id}.#{@proj_name}"
        set_CFBundleName = "Set :CFBundleName #{@proj_name}"
        set_CFBundlePackageType = 'Set :CFBundlePackageType APPL'
        set_UIAppSceneManifest = "Set :UIApplicationSceneManifest:UISceneConfigurations:UIWindowSceneSessionRoleApplication:0:UISceneDelegateClassName #{@proj_name}.SceneDelegate"

        Utils.sh "#{plist_buddy} -c '#{set_CFBundleExecutable}' #{Info.user_temp_full}/Info.plist", @verbose, @debug
        Utils.sh "#{plist_buddy} -c '#{set_CFBundleIdentifier}' #{Info.user_temp_full}/Info.plist", @verbose, @debug
        Utils.sh "#{plist_buddy} -c '#{set_CFBundleName}' #{Info.user_temp_full}/Info.plist", @verbose, @debug
        Utils.sh "#{plist_buddy} -c '#{set_CFBundlePackageType}' #{Info.user_temp_full}/Info.plist", @verbose, @debug
        Utils.sh "#{plist_buddy} -c '#{set_UIAppSceneManifest}' #{Info.user_temp_full}/Info.plist", @verbose, @debug

        Utils.sh "cp  #{Info.user_temp_full}/Info.plist #{Info.user_builds_full}/#{@proj_name}.app/Info.plist", @verbose, @debug
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
