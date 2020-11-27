#!/usr/bin/env ruby

require_relative '../lib/cli'

Dir.chdir __dir__
Dir.chdir '../'

CLI::Config.setup
# CLI::Command.run WIP
