module CLI
  module Utils
    require_relative 'ui'
    require_relative 'info'

    def self.user_input(text)
      UI.log text.to_s, 'blue'
      STDIN.gets.chomp.to_s
    end

    def self.sh(command, verbose=false)
      UI.log command, 'pink' if verbose
      %x[#{command}]
    end

    def self.clear_dir(path, verbose=false)
      if !path.include?('..') && path.include?(Info.user_data)
        self.sh "rm -r #{path}/*", verbose
      else
        UI.log 'Invalid path', 'red'
        abort
      end
    end
  end
end
