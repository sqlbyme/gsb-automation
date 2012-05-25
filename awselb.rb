require 'rubygems'
require 'bundler/setup'
require './lib/globalconfig'
require 'yaml'
require 'aws-sdk'



class AwsElb
 
  attr_accessor :loadBalancer
  
  def initialize()
    @configYAML = YAML::load(File.open('./config/config.yml'))
    @config = ::GlobalConfig.new()
    @config.aws_access_key = @configYAML[ENV['APP_ENV']]['aws_access_key']
    @config.aws_secret_key = @configYAML[ENV['APP_ENV']]['aws_secret_key']
    @config.elb_name = @configYAML[ENV['APP_ENV']]['elb_name']
    AWS.config({ :access_key_id => @config.aws_access_key, :secret_access_key => @config.aws_secret_key})
    @loadBalancer = AWS::ELB::LoadBalancer.new('GSB')
  end
  
end
