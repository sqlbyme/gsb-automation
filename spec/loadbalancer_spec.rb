# AWS::ELB spec file

require './loadbalancer'



describe "LoadBalancer Class" do
  before(:all) do
    @load_balancer = LoadBalancer.new()
  end
  
  describe "Initialize" do
    it "should create a new instance of the named load balancer." do
      @load_balancer.to_s.empty? # => false
      @load_balancer.load_balancer.name.should == 'GSB'
    end
  end
  
  describe "get_instances" do
    it "should return an array of the instances associated with the named load balancer." do
      @load_balancer.get_instances(@load_balancer.load_balancer.instances).should == []
    end
  end
end
