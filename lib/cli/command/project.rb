module CLI
  class Command
    class Project < Command
      require_relative '../config'
      require_relative '../ui'

      attr_reader :verbose 

      def self.description()
        'Project method [add, select, edit]'
      end

      def run(options)
        @verbose = options[:verbose]
        self.parse_command options[:command]
      end

      def parse_command(command)
        command = command.gsub('=', '')
        options = ['select', 'add', 'edit']
        (UI.log 'Invalid option', 'red'; abort) unless options.include? command
        eval "self.#{command}"
      end

      def add()
        Config.add_project
        Config.current_project
      end

      def edit()
        puts 'edit'
      end

      def select()
        Config.select_project
        Config.current_project
      end

      private :parse_command,
        :add,
        :edit,
        :select
    end
  end
end
