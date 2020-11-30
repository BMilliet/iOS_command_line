module CLI
  require_relative 'cli/command'
  require_relative 'cli/config'
  require_relative 'cli/utils'
  require_relative 'cli/info'
  require_relative 'cli/ui'

  autoload :Command,  'cli/command'
  autoload :Config,   'cli/config'
  autoload :Utils,    'cli/utils'
  autoload :Info,     'cli/info'
  autoload :UI,       'cli/ui'
end
