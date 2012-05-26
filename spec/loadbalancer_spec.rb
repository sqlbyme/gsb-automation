# AWS::ELB spec file

require './loadbalancer'


describe "LoadBalancer Class" do
  before(:all) do
    @load_balancer = ::LoadBalancer.new()
  end
  describe "Initialize" do
    it "should create a new instance of the named load balancer." do
      @load_balancer.to_s.empty? # => false
      @load_balancer.load_balancer.name.should == 'GSB'
    end
  end
  
end
