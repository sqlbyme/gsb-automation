require 'rubygems'
require 'bundler/setup'
require './lib/aws_wrapper'

  gsb = AwsWrapper.new()

  puts "Starting GSB Server Refresh..."
  
  puts "Fetching Existing Instance ID's."
  
  gsb.get_curent_lb_instances
  
  puts "Creating new servers from ami-image."
  
  gsb.create_new_ec2instances
  
  puts "Waiting for new servers to be ready."
  
  gsb.servers_setup?
  gsb.snooze
  gsb.servers_running?
  
  puts "Adding new servers to Load Balancer."
  
  gsb.add_servers_to_lb
  
  puts "Removing old servers from Load Balancer."
  
  gsb.deregister_dep_servers
  
  puts "Terminating deprecated instances."
  
  gsb.terminate_dep_servers
  
  puts "Checking that getsongbird.com is really running..."
  
  gsb.check_gsb_up
  
  puts "All Done!"
  