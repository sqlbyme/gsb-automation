class GlobalConfig
  def initialize(environment, gems, aws)
    @environment = environment
    @gems = gems
    @aws = aws
  end
  
  def environment
    @environment
  end
  
  def gems
    @gems
  end
  
  def aws
    @aws
  end
  
 def aws_key
   @aws_key = ''
 end
 
 def aws_secret
   @aws_secret = ''
 end
 
end
