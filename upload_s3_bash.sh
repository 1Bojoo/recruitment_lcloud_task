#!/usr/bin/bash

output_file="instance_info.txt"

instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
public_ip=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
private_ip=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
sec_groups=$(curl -s http://169.254.169.254/latest/meta-data/security-groups)

os_info=$(cat /etc/os-release | grep -E "^PRETTY_NAME")

users=$(getent passwd | awk -F: '$7 ~ /bash|sh/ {print $1}')

echo "Instance ID: $instance_id" > $output_file
echo "Public IP: $public_ip" >> $output_file
echo "Private IP: $private_ip" >> $output_file
echo "Security Gropus: $sec_groups" >> $output_file
echo "Operating System: $os_info" >> $output_file
echo "Users: $users" >> $output_file

aws s3 cp $output_file s3://applicant-task/r4p17/

echo "Data has been uploaded to S3"
