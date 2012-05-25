require "./lib/globalconfig"
require "yaml"

@configYAML = YAML::load(File.open('./config/config.yml'))
@config = ::GlobalConfig.new()
@config.gems = @configYAML[ENV['APP_ENV']]['gems']
@config.aws_access_key = @configYAML[ENV['APP_ENV']]['aws_access_key']
@config.aws_secret_key = @configYAML[ENV['APP_ENV']]['aws_secret_key']
@config.elb_name = @configYAML[ENV['APP_ENV']]['elb_name']

class AwsElb
 
  attr_accessor :loadBalancer
  
  def initialize()
    @loadBalancer = AWS::ELB::LoadBalancer.new('GSB')
  end
  
end
