require 'rubygems'
require 'bundler/setup'
require './lib/globalconfig'
require 'yaml'
require 'aws-sdk'



class LoadBalancer
 
  attr_accessor :load_balancer
  
  def initialize()
    @configYAML = YAML::load(File.open('./config/config.yml'))
    @config = ::GlobalConfig.new()
    @config.aws_access_key = @configYAML[ENV['APP_ENV']]['aws_access_key']
    @config.aws_secret_key = @configYAML[ENV['APP_ENV']]['aws_secret_key']
    @config.load_balancer_name = @configYAML[ENV['APP_ENV']]['load_balancer_name']
    AWS.config({ :access_key_id => @config.aws_access_key, :secret_access_key => @config.aws_secret_key})
    @load_balancer = AWS::ELB::LoadBalancer.new(@config.load_balancer_name)
  end
  
  def get_instances(collection)
    instances = @collection.instances
    instances.each { |instance| instance_array.put(AWS::EC2::Instance.new(instance.id)) }
  end

end
