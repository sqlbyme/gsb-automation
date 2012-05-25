# environment rspec file

require "./lib/environment"

describe "Environment" do
  before (:all) do
    @env = ::Environment.new()
  end
  
  describe "class initialize" do
    it "should load the config.yml file and process it" do
      @env.configYAML.empty? # => false
      @env.configYAML['environment'].should ||= 'development' 'production' 
    end
  end


end
  
 