module CLI
  class Command
    require 'optparse'
    require_relative 'command/build'

    def self.run()
      options = {}
      main = nil

      OptionParser.new do |opt|
        opt.banner = 'Usage: cli.rb [command]=<param> [subcommand]'
        opt.separator ''
        opt.on('-v', '--[no-]verbose', 'Run verbosely') { |v| options[:verbose] = v }
        opt.on('-b', '--build') { |command| options[:command] = command; main = Build.new }
        opt.on('-r', '--run') { |command| options[:command] = command; main = Launch.new }
        opt.on('-h', '--help', "help command") { puts opt; exit }
      end.parse!

      main.run options
    end
  end
end
