class GlobalConfig
  attr_accessor :environment, :gems, :aws

  def initialize(environment, gems, aws)
    @environment = environment
    @gems = gems
    @aws= aws
  end
  
  
end
