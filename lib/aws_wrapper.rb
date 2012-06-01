require './lib/globalconfig'
require 'yaml'
require 'aws-sdk'
require 'http'

class AwsWrapper

  def initialize()
    configYAML = YAML::load(File.open('./config/config.yml'))
    @config = GlobalConfig.new()
    @config.aws_access_key = configYAML[ENV['APP_ENV']]['aws_access_key']
    @config.aws_secret_key = configYAML[ENV['APP_ENV']]['aws_secret_key']
    @config.load_balancer_name = configYAML[ENV['APP_ENV']]['load_balancer_name']
    AWS.config({ :access_key_id => @config.aws_access_key,
                 :secret_access_key => @config.aws_secret_key,
                 :use_ssl => true })
    @ec2 = AWS::EC2.new()
    @lb = AWS::ELB::InstanceCollection.new(AWS::ELB::LoadBalancer.new("GSB"))
  end

  def get_curent_lb_instances()
    @deregisterArray = []
    @lb.each do |instance|
      @deregisterArray.push(:id => instance.id)
    end
  end
  
  def create_new_ec2instances()
  
    @servers_us_east_1a = @ec2.instances.create(:image_id => "ami-635f8e0a", 
                                              :instance_type => "t1.micro",
                                              :security_groups => ['WFE'],
                                              :availability_zone => 'us-east-1a',
                                              :count => 2 )

    @servers_us_east_1d = @ec2.instances.create(:image_id => "ami-635f8e0a", 
                                              :instance_type => "t1.micro",
                                              :security_groups => ['WFE'],
                                              :availability_zone => 'us-east-1d',
                                              :count => 2 )
  
  end
  
  def servers_setup?()
    print "Waiting on server 1."
    begin
      sleep 1 until @servers_us_east_1a[0].status == :running
      puts ""
      puts "Server 1 is ready."
    rescue
      print "."
      retry
    end
    print "Waiting on server 2."
    begin
      sleep 1 until @servers_us_east_1a[1].status == :running
      puts ""
      puts "Server 2 is ready."
    rescue
      print "."
      retry
    end
    print "Waiting on server 3."
    begin
      sleep 1 until @servers_us_east_1d[0].status == :running
      puts ""
      puts "Server 3 is ready."
    rescue
      print "."
      retry
    end
    print "Waiting on server 4."
    begin
      sleep 1 until @servers_us_east_1d[1].status == :running
      puts ""
      puts "Server 4 is ready."
    rescue
      print "."
      retry
    end
  end
  
  def servers_running?()
    print "Waiting on a 200 response from server 1."
    begin
      sleep 10 until Http.head("http://" + @servers_us_east_1a[0].dns_name).status == 200
      puts ""
      puts "Server 1 running."
    rescue
      print "."
      retry
    end
    print "Waiting on a 200 response from server 2."
    begin
      sleep 10 until Http.head("http://" + @servers_us_east_1a[1].dns_name).status == 200
      puts ""
      puts "Server 2 running."
    rescue
      print "."
      retry
    end
    print "Waiting on a 200 response from server 3."
    begin
      sleep 10 until Http.head("http://" + @servers_us_east_1d[0].dns_name).status == 200
      puts ""
      puts "Server 3 running."
    rescue
      print "."
      retry
    end
    print "Waiting on a 200 response from server 4."
    begin
      sleep 10 until Http.head("http://" + @servers_us_east_1d[1].dns_name).status == 200
      puts ""
      puts "Server 4 running."
    rescue
      print "."
      retry
    end
  end
  
  def snooze()
    puts "********** SLEEPING FOR 45 SECONDS **********"
    sleep 45
  end
  
  def add_servers_to_lb()
    @servers_us_east_1a.each do |instance|
      @lb.add(instance)
    end

    @servers_us_east_1d.each do |instance|
      @lb.add(instance)
    end
  end
  
  def deregister_dep_servers()
    @deregisterArray.each do |instance|
      @lb.remove(instance[:id])
    end
  end
  
  def terminate_dep_servers()
    @deregisterArray.each do |instance|
      @ec2.instances[instance[:id]].terminate
    end
  end
  
  def check_gsb_up()
    print "Waiting on 200 response from getsongbird.com."
    begin
      5.times { sleep 5 until Http.head("http://getsongbird.com").status == 200 }
      puts ""
      puts "getsongbird.com is now running."
    rescue
      print "."
      retry
    end
  end



end