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
    @lb = AWS::ELB.new().load_balancers["GSB"].instances
    @lb_eu = AWS::ELB.new(:elb_endpoint => 'elasticloadbalancing.eu-west-1.amazonaws.com').load_balancers["GSB"].instances
    
    # Setup Data Centers
    @dc_us_east_1 = @ec2.regions["us-east-1"]
    @dc_eu_west_1 = @ec2.regions["eu-west-1"]
    
  end

  def get_curent_lb_instances()
    @deregisterArray = []
    @deregisterArray_eu = []
    
    @lb.each do |instance|
      @deregisterArray.push(:id => instance.id)
    end
    @lb_eu.each do |instance|
      @deregisterArray_eu.push(:id => instance.id)
    end
  end
  
  def create_new_ec2instances()
  
    
    
    # Create US Server Instances First
    @servers_us_east_1a = @dc_us_east_1.instances.create(:image_id => "ami-1169c778", 
                                                        :instance_type => "t1.micro",
                                                        :security_groups => ['WFE'],
                                                        :availability_zone => 'us-east-1a',
                                                        :block_device_mappings => { '/dev/sda1' => {:snapshot_id => 'snap-74791c05', :volume_size => '8GB', :delete_on_termination => true} },
                                                        :count => 2 )

    @servers_us_east_1d = @dc_us_east_1.instances.create(:image_id => "ami-1169c778", 
                                                        :instance_type => "t1.micro",
                                                        :security_groups => ['WFE'],
                                                        :availability_zone => 'us-east-1d',
                                                        :block_device_mappings => { '/dev/sda1' => {:snapshot_id => 'snap-74791c05', :volume_size => '8GB', :delete_on_termination => true} },
                                                        :count => 2 )
  
  # Create European Server Instances next
  @servers_eu_west_1a = @dc_eu_west_1.instances.create(:image_id => "ami-1f8e8a6b",
                                                      :instance_type => "t1.micro",
                                                      :security_groups => "WFE",
                                                      :availability_zone => "eu-west-1a",
                                                      :count => 2 )

  @servers_eu_west_1c = @dc_eu_west_1.instances.create(:image_id => "ami-1f8e8a6b",
                                                      :instance_type => "t1.micro",
                                                      :security_groups => "WFE",
                                                      :availability_zone => "eu-west-1c",
                                                      :count =>2 )
  end
  
  def servers_setup?()
    print "Waiting on server US-1."
    begin
      sleep 1 until @servers_us_east_1a[0].status == :running
      puts ""
      puts "Server 1 is ready."
      @servers_us_east_1a[0].tag('Name', :value => 'GSB_WFE_US-EAST-1A-1')
    rescue
      print "."
      retry
    end
    print "Waiting on server US-2."
    begin
      sleep 1 until @servers_us_east_1a[1].status == :running
      puts ""
      puts "Server 2 is ready."
      @servers_us_east_1a[1].tag('Name', :value => 'GSB_WFE_US-EAST-1A-2')
    rescue
      print "."
      retry
    end
    print "Waiting on server US-3."
    begin
      sleep 1 until @servers_us_east_1d[0].status == :running
      puts ""
      puts "Server 3 is ready."
      @servers_us_east_1d[0].tag('Name', :value => 'GSB_WFE_US-EAST-1D-1')
    rescue
      print "."
      retry
    end
    print "Waiting on server US-4."
    begin
      sleep 1 until @servers_us_east_1d[1].status == :running
      puts ""
      puts "Server 4 is ready."
      @servers_us_east_1d[1].tag('Name', :value => 'GSB_WFE_US-EAST-1D-2')
    rescue
      print "."
      retry
    end
  # End US Setup
  # Begin EU Setup
    print "Waiting on server EU-1."
    begin
      sleep 1 until @servers_eu_west_1a[0].status == :running
      puts ""
      puts "Server EU-1 is ready."
      @servers_eu_west_1a[0].tag('Name', :value => 'GSB_WFE_EU-WEST-1A-1')
    rescue
      print "."
      retry
    end
    print "Waiting on server EU-2."
    begin
      sleep 1 until @servers_eu_west_1a[1].status == :running
      puts ""
      puts "Server EU-2 is ready."
      @servers_eu_west_1a[1].tag('Name', :value => 'GSB_WFE_EU-WEST-1A-2')
    rescue
      print "."
      retry
    end
    print "Waiting on server EU-3."
    begin
      sleep 1 until @servers_eu_west_1c[0].status == :running
      puts ""
      puts "Server EU-3 is ready."
      @servers_eu_west_1c[0].tag('Name', :value => 'GSB_WFE_EU-WEST-1C-1')
    rescue
      print "."
      retry
    end
    print "Waiting on server EU-4."
    begin
      sleep 1 until @servers_eu_west_1c[1].status == :running
      puts ""
      puts "Server EU-4 is ready."
      @servers_eu_west_1c[1].tag('Name', :value => 'GSB_WFE_EU-WEST-1C-2')
    rescue
      print "."
      retry
    end
  # End EU Setup
  end

  def servers_running?()
    print "Waiting on a 200 response from server US-1."
    begin
      sleep 10 until Http.head("http://" + @servers_us_east_1a[0].dns_name).status == 200
      puts ""
      puts "Server 1 running."
    rescue
      print "."
      retry
    end
    print "Waiting on a 200 response from server US-2."
    begin
      sleep 10 until Http.head("http://" + @servers_us_east_1a[1].dns_name).status == 200
      puts ""
      puts "Server 2 running."
    rescue
      print "."
      retry
    end
    print "Waiting on a 200 response from server US-3."
    begin
      sleep 10 until Http.head("http://" + @servers_us_east_1d[0].dns_name).status == 200
      puts ""
      puts "Server 3 running."
    rescue
      print "."
      retry
    end
    print "Waiting on a 200 response from server US-4."
    begin
      sleep 10 until Http.head("http://" + @servers_us_east_1d[1].dns_name).status == 200
      puts ""
      puts "Server 4 running."
    rescue
      print "."
      retry
    end
    print "Waiting on a 200 response from server EU-1."
    begin
      sleep 10 until Http.head("http://" + @servers_eu_west_1a[0].dns_name).status == 200
      puts ""
      puts "Server 4 running."
    rescue
      print "."
      retry
    end
    print "Waiting on a 200 response from server EU-2."
    begin
      sleep 10 until Http.head("http://" + @servers_eu_west_1a[1].dns_name).status == 200
      puts ""
      puts "Server 4 running."
    rescue
      print "."
      retry
    end
    print "Waiting on a 200 response from server EU-3."
    begin
      sleep 10 until Http.head("http://" + @servers_eu_west_1c[0].dns_name).status == 200
      puts ""
      puts "Server 4 running."
    rescue
      print "."
      retry
    end
    print "Waiting on a 200 response from server EU-4."
    begin
      sleep 10 until Http.head("http://" + @servers_eu_west_1c[1].dns_name).status == 200
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
    
    @servers_eu_west_1a.each do |instance|
      @lb_eu.add(instance)
    end
    
    @servers_eu_west_1c.each do |instance|
      @lb_eu.add(instance)
    end
  end
  
  def deregister_dep_servers()
    @deregisterArray.each do |instance|
      @lb.remove(instance[:id])
    end
    @deregisterArray_eu.each do |instance|
      @lb_eu.remove(instance[:id])
    end
  end
  
  def terminate_dep_servers()
    @deregisterArray.each do |instance|
      @dc_us_east_1.instances[instance[:id]].terminate
    end
    @deregisterArray_eu.each do |instance|
      @dc_eu_west_1.instances[instance[:id]].terminate
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