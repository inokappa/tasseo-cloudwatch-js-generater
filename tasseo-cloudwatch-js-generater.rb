#!/usr/bin/env ruby

require 'aws-sdk'
require 'json'

def config
{
  :tasseo => '/path/to/tasseo',
  :dashboard => '/path/to/tasseo/dashboards/',
  :aws_key => '',
  :aws_secret_key => '',
  :endpoint => 'ec2.ap-northeast-1.amazonaws.com',
}
end

def generate_js(instance)
  metrics_names = {
    'CPUUtilization' => '%',
    'DiskReadOps' => 'Num',
    'DiskWriteOps' => 'Num',
    'DiskReadBytes' => 'Byte',
    'DiskWriteBytes' => 'Byte',
    'NetworkIn' => 'Byte',
    'NetworkOut' => 'Byte',
  }

  v = []
  metrics_names.each do |metrics,units|
    statistics = {
      :target      => "#{metrics}(#{units})",
      :Namespace   => "AWS/EC2",
      :MetricName => "#{metrics}",
      :Statistics  => ['Average'],
      :Dimensions  => [
        { :Name => "InstanceId", :Value => "#{instance}" },
      ]
    }
    v << JSON.pretty_generate(statistics)
  end

  v.join(",\n")
end

def get_instances
  ec2 = AWS::EC2.new(
    :access_key_id => config[:aws_key],
    :secret_access_key => config[:aws_secret_key],
    :ec2_endpoint => config[:endpoint],
  ).client

  ec2.describe_instances(:filters => [{ 'name' => 'instance-state-name', 'values' => ['running'] }])
end

# output
unless get_instances.reservation_set != nil then
  get_instances.reservation_set.each do |instances_set|
    instances_set[:instances_set].each do |instance|
      File.open("#{config[:dashboard]}#{instance[:instance_id]}.js","w") do |file|
        file.puts "var period = 60;"
        file.puts "var refresh = 1 * 60 * 1000;"
        file.puts "var usingCloudWatch = true;"
        file.puts "var metrics = ["
        file.puts generate_js instance[:instance_id]
        file.puts "]"
      end
      puts instance[:instance_id] + "'s JavaScript File Created."
    end 
  end
else
  puts "Running instance does not exists."
end
