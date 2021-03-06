module CLI
  module Config
    require 'yaml'
    require_relative 'info'
    require_relative 'ui'
    require_relative 'utils'

    def self.setup
      self.setup_basic_dirs

      if Info.user_selected_project.nil?
        Info.user_has_project? ? self.select_project : self.add_project
      end
      self.current_project
    end

    def self.setup_basic_dirs()
      Dir.mkdir Info.cli_out unless File.exists? Info.cli_out
      Dir.mkdir Info.user_data unless File.exists? Info.user_data
      Dir.mkdir Info.user_builds unless File.exists? Info.user_builds
      Dir.mkdir Info.user_temp unless File.exists? Info.user_temp

      unless File.exists? Info.user_config
        yml = { ios_projs: [], selected: nil }
        self.save_user_config yml
      end
    end

    def self.add_project()
      UI.log 'Add new project', 'blue'
      path = Utils.user_input 'Enter project path:'
      name = Utils.user_input 'Enter project name:'
      bundle_id = Utils.user_input 'Enter project bundle id:'
      new = {name: name, bundle_id: bundle_id, path: path}
      yml = YAML::load_file Info.user_config
      yml[:ios_projs] << new
      yml[:selected] = new
      self.save_user_config yml
    end

    def self.select_project()
      UI.log 'You have the following projects:', 'blue'
      selected = UI.select_option Info.user_projects_names
      Info.user_projects.each { |p| selected = p if p[:name] == selected }
      yml = YAML::load_file Info.user_config
      yml[:selected] = selected
      self.save_user_config yml
    end

    def self.current_project()
      UI.log "Current project: #{Info.user_selected_project_name}", 'blue'
    end

    private
    def self.save_user_config(yml)
      File.open(Info.user_config, 'w') { |f| f.write yml.to_yaml }
    end
  end
end
