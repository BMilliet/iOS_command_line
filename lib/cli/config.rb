module CLI
  module Config
    require 'yaml'
    require_relative 'info'
    require_relative 'ui'

    def self.setup
      Dir.mkdir Info.cli_out unless File.exists? Info.cli_out
      Dir.mkdir Info.user_data unless File.exists? Info.user_data

      unless File.exists? Info.user_config
        yml = { ios_projs: [], selected: nil }
        File.open(Info.user_config, 'w') { |f| f.write yml.to_yaml }
      end

      if Info.user_selected_project.nil?
        Info.user_has_project? ? self.select_project : self.add_project
      end
    end

    def self.add_project()
      UI.log "You dont have any project registered\nAdd ios project root dir full path:", 'blue'
      # new_project = gets.chomp.to_s
    end

    def self.select_project()
      UI.log 'You have the following projects:', 'blue'
    end
  end
end
