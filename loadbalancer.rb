require 'rubygems'
require 'bundler/setup'
require './lib/globalconfig'
require 'yaml'
require 'aws-sdk'




 
  
  @configYAML = YAML::load(File.open('./config/config.yml'))
  @config = ::GlobalConfig.new()
  @config.aws_access_key = @configYAML[ENV['APP_ENV']]['aws_access_key']
  @config.aws_secret_key = @configYAML[ENV['APP_ENV']]['aws_secret_key']
  @config.load_balancer_name = @configYAML[ENV['APP_ENV']]['load_balancer_name']
  AWS.config({ :access_key_id => @config.aws_access_key, :secret_access_key => @config.aws_secret_key})
  @mylb = AWS::ELB::LoadBalancer.new(@config.load_balancer_name)
  @instance_array = []
  
  # Get an array of the EC2 instances so that we can iterate through them later, also write 
  # a hash of the current instance id's, region and availability-zone.
  def get_instances(collection)
    collection.each { |instance| @instance_array.push(AWS::EC2::Instance.new(instance.id)) }
    return @instance_array
  end
  
  # TODO - Write a method which will remove an EC2 instance from the LB. TBD - to see how we determine that the 
  # instance has been successfully removed.
  def deregister
  # TODO - Write a method which will terminate the just removed EC2 instance.  TBD - how we ensure that the 
  # instance we are about to terminate is in fact the one we just removed from the LB.
  
  # TODO - Write a method which will create a new EC2 Instance from our GSB-AMI and create
  # the new instance in corresponding region and availability-zone as the just terminated instance.
  
  # TODO - Write a method to check that a newly spun up EC2 instance is serving the correct version of the
  # getongbird.com website
  
  # TODO - Write a method to register the newly verified EC2 instance wiht our LB.

