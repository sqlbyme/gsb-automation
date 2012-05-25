# config rspec file

require "./lib/globalconfig"

describe GlobalConfig do
  before(:all) do
    @config = ::GlobalConfig.new( 'development', ['rubygems', 'rspec'], ['123456', '1234567'])
  end
  
  describe "environment" do
    it "should be equal to the string 'development'." do
      @config.environment.should == "development" 
    end
  end
  
  describe "gems" do
    it "should return an array of gems to require." do
      @config.gems.should == ['rubygems', 'rspec']
    end
  end
  
  describe "aws" do
    it "should return an array containg the aws key and secrent needed for the API call." do
      @config.aws.should == ['123456', '1234567']
    end
  end
end
