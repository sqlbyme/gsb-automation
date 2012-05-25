# This file is used to setup or ruby environement to ensure our script runs correctly

require 'rubygems'
require 'bundler/setup'
require 'yaml'
require File.expand_path(File.join(File.dirname(__FILE__), "globalconfig"))

class Environment
  attr_accessor :configYAML, :config
  
  def initialize()
    # YAML#load_file
    @configYAML = YAML::load(File.open('./config/config.yml'))
    @config = ::GlobalConfig.new(configYAML['environment'], configYAML['gems'], configYAML['aws'])
    
    case @config.environment
      when 'development'
        @config.gems['development']['gems'].each { |g| require "#{g}"}
        AWS.config({ :access_key_id => config.aws['development']['aws_access_key'], :secret_access_key => config.aws['development']['aws_secret_key'], })
      when 'production'
        @config.gems['production']['gems'].each { |g| require "#{g}"}
        AWS.config({ :access_key_id => config.aws['production']['aws_access_key'], :secret_access_key => config.aws['production']['aws_secret_key'], })
      end
  end
end