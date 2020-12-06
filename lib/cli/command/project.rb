module CLI
  class Command
    class Project < Command
      require_relative '../config'
      require_relative '../ui'

      attr_reader :verbose 

      def self.description()
        'Edit, add, delete and select projects'
      end

      def run(options)
        @verbose = options[:verbose]
        self.parse_command options[:command]
      end

      def parse_command(command)
        case command
        when '=select';   Config.select_project; Config.current_project
        when '=add';      Config.add_project; Config.current_project
        when '=edit';     puts 'edit'
        else
          UI.log 'Invalid option', 'red'
          UI.log 'Options: select, add, edit', 'blue'
        end
      end
    end
  end
end
