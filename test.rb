require "./lib/environment"


myELB = AWS::ELB::LoadBalancer.new('GSB')



#myELB.instances.deregister(AWS::EC2::Instance.new('i-ffdd749a'))
myELB.instances.each { |instance| myInst = AWS::EC2::Instance.new(instance.id); puts myInst.id }
puts
#myInst = AWS::EC2::Instance.new('i-ffdd749a')
#puts
#myELB.instances.register(AWS::EC2::Instance.new('i-ffdd749a'))
#myELB.instances.each { |instance| myInst = AWS::EC2::Instance.new(instance.id); puts myInst.id }





