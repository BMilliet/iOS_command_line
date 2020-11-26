module CLI
  module Info
    require 'yaml'

    def self.cli_out()
      'resources/cli_out'
    end

    def self.user_data()
      'resources/user_data'
    end

    def self.user_config()
      'resources/user_data/user_config.yml'
    end

    def self.user_config_yml()
      YAML.load(File.read self.user_config)
    end

    def self.user_projects()
      self.user_config_yml[:ios_projs]
    end

    def self.user_selected_project()
      self.user_config_yml[:selected]
    end

    def self.user_has_project?()
      !self.user_projects.empty?
    end
  end
end
