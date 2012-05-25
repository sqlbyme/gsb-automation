# config rspec file

require "./lib/globalconfig"
require "yaml"

describe "GlobalConfig" do
  before(:all) do
    @config = ::GlobalConfig.new()
    @configYAML = YAML::load(File.open('./config/config.yml'))
    @config.gems = @configYAML[ENV['APP_ENV']]['gems']
    @config.aws_access_key = @configYAML[ENV['APP_ENV']]['aws_access_key']
    @config.aws_secret_key = @configYAML[ENV['APP_ENV']]['aws_secret_key']
    @config.elb_name = @configYAML[ENV['APP_ENV']]['elb_name']
  end

  describe "YAML Load" do
    it "should load the config.yml file." do
      @configYAML.empty? # => false
    end
  end
  
  describe "gems" do
    it "should return an array of gems to require." do
      @config.gems.should == ['aws-sdk']
    end
  end
  
  describe "aws_access_key" do
    it "should return the aws key needed for the API call." do
      @config.aws_access_key.should == 'AKIAJQ4I32FNR26CB3OQ'
    end
  end
  
  describe "aws_secret_key" do
    it "should return the aws secret needed for the API call." do
      @config.aws_secret_key.should == 'Mp6jNDf29HAqxoKHraoTW9CrxDhHTxah3IdroMBM'
    end
  end
  
  describe "elb_name" do
    it "should return the name of the ELB instance we are working on." do
      @config.elb_name.should == 'GSB'
    end
  end
end
