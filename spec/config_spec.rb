# config rspec file

require "./lib/config"
require "yaml"

describe "Config" do
  before(:all) do
    @config = ::Config.new()
    @configYAML = YAML.load_file('./config/config.yml')
    @config.aws_access_key = @configYAML['aws_access_key']
    @config.
  end
  
  describe "YAML Load" do
    it "should load the config.yml file." do
      @configYAML.empty? # => false
    end
  end
  
  describe "gems" do
    it "should return an array of gems to require." do
      @config.gems.empty?
    end
  end
  
  describe "aws_access_key" do
    it "should return the aws key needed for the API call." do
      @config.aws_access_key.empty?
    end
  end
  
  describe "aws_secret_key" do
    it "should return the aws secret needed for the API call." do
      @config.aws_secret_key.empty?
    end
  end
end
