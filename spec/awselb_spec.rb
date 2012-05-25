# AWS::ELB spec file

require './awselb'

describe "AWS ELB Class" do
  before(:all) do
    @awselb = ::AwsElb.new()
  end
  describe "loadBalancer" do
    it "should create a new instance of the named load balancer." do
      @awselb.loadBalancer.empty? # => false
      @awselb.loadBalancer.name.should == 'GSB'
    end
  end
end
