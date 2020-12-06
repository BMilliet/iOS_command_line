module CLI
  class Command
    require 'optparse'
    require_relative 'command/build'
    require_relative 'command/launch'
    require_relative 'command/project'

    def self.run()
      options = {}
      main = nil

      OptionParser.new do |opt|
        opt.banner = 'Usage: cli.rb [command]=<param> [subcommand]'
        opt.separator ''
        opt.on('-v', '--[no-]verbose', 'Run verbosely') { |v| options[:verbose] = v }
        opt.on('-r', '--run', Launch.description) { |c| options[:command] = c; main = Launch.new }
        opt.on('-b', '--build', Build.description) { |c| options[:command] = c; main = Build.new }
        opt.on('-p', '--project=PARAM', Project.description) { |c| options[:command] = c; main = Project.new }
        opt.on('-h', '--help', "Display help") { puts opt; exit }
      end.parse!

      main.run options
    end
  end
end
