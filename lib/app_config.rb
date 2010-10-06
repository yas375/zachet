# Load application configuration
require 'ostruct'
require 'yaml'

config = OpenStruct.new(YAML.load_file("#{RAILS_ROOT}/config/app_config.yml"))
::AppConfig = OpenStruct.new(config.send(RAILS_ENV))
