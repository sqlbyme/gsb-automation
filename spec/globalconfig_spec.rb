# config rspec file

require "./lib/globalconfig"
require "yaml"

describe "GlobalConfig" do
  before(:all) do
    @config = ::GlobalConfig.new()
    @configYAML = YAML::load(File.open('./config/config.yml'))
    @config.aws_access_key = @configYAML['aws_access_key']
    @config.aws_secret_key = @configYAML['aws_secret_key']
  end

  describe "YAML Load" do
    it "should load the config.yml file." do
      @configYAML.empty? # => false
    end
  end
  
  describe "gems" do
    it "should return an array of gems to require." do
      @config.gems.empty? # => false
    end
  end
  
  describe "aws_access_key" do
    it "should return the aws key needed for the API call." do
      @config.aws_access_key.empty? # => false
    end
  end
  
  describe "aws_secret_key" do
    it "should return the aws secret needed for the API call." do
      @config.aws_secret_key.empty? # => false
    end
  end
end
