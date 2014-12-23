tasseo-cloudwatch-js-generater
==============================

### About this

 * CloudWatch setting file(JavaScript) generater for [Tasseo](https://github.com/obfuscurity/tasseo) 

### Require

 * aws-sdk for Ruby

### How to use
#### added credential infomation

Please define following.

 * tasseo installed path
 * tasseo `dashboards` path
 * AWS ACCESS KEY
 * AWS SECRET ACCESS KEY
 * EC2 Endpoint

~~~
def config
{
  :tasseo => '/path/to/tasseo',
  :dashboard => '/path/to/tasseo/dashboards/',
  :aws_key => 'AKxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
  :aws_secret_key => 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
  :endpoint => 'ec2.ap-northeast-1.amazonaws.com',
}
end
~~~

#### Generate

~~~
./tasseo-cloudwatch-js-generater.rb
~~~

#### Confirm "dashboards" Directory

~~~
cd /path/to/tasseo/dashboard
~~~

#### Generated file example

Instance ID becomes the file name.

~~~i-xxxxxx.js
var period = 60;
var refresh = 1 * 60 * 1000;
var usingCloudWatch = true;
var metrics = [
{
  "target": "CPUUtilization(%)",
  "Namespace": "AWS/EC2",
  "MetricName": "CPUUtilization",
  "Statistics": [
    "Average"
  ],
  "Dimensions": [
    {
      "Name": "InstanceId",
      "Value": "${instance_id}"
    }
  ]
},
{
  "target": "DiskReadOps(Num)",
  "Namespace": "AWS/EC2",
  "MetricName": "DiskReadOps",
  "Statistics": [
    "Average"
  ],
  "Dimensions": [
    {
      "Name": "InstanceId",
      "Value": "${instance_id}"
    }
  ]
},
(snip)
{
  "target": "NetworkOut(Byte)",
  "Namespace": "AWS/EC2",
  "MetricName": "NetworkOut",
  "Statistics": [
    "Average"
  ],
  "Dimensions": [
    {
      "Name": "InstanceId",
      "Value": "${instance_id}"
    }
  ]
}
]
~~~
