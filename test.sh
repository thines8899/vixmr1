#!/bin/bash

# Định nghĩa tên Mẫu khởi chạy (Launch Template) cho từng vùng

d
declare -A REGION_TEMPLATES
REGION_TEMPLATES[
REGION_TEMPLATE

REGION
"us-east-1"]="SpotLaunchTemplate-us-east-1"
REGION_TEMPLATES[
REGION_TEMPLAT

REGION_
"us-west-2"]="SpotLaunchTemplate-us-west-2"
REGION_TEMPLATES[
REGION_TEMPLATES[

REGION_T
"us-east-2"]="SpotLaunchTemplate-us-east-2"

# Số lượng instances cần tạo ở mỗi vùng
INSTANCE_COUNT=8


INSTANCE_CO
# Vòng lặp qua từng vùng và Mẫu khởi chạy để tạo instances
for REGION in "${!REGION_TEMPLATES[@]}"; do
    TEMPLATE=
    TEM
${REGION_TEMPLATES[$REGION]}
    
    e
echo "Launching $INSTANCE_COUNT instances in $REGION using Launch Template $TEMPLATE..."
    
    
    
    
# Chạy lệnh AWS CLI để tạo Spot Instances trong vùng tương ứng
    aws ec2 run-instances \
        --launch-template LaunchTemplateName=
    aws ec2 run-instances \
        --launch-template LaunchTemp

    aws ec2 run-instances \
        --launch-templat

    aws ec2 run-instances \
        --l

    aws ec2 run-instance

    aws ec2 run-i

    aws e
$TEMPLATE,Version=1 \
        --instance-market-options MarketType=on-demand \
        --count 
        --instance-market-options MarketType=on-demand \
        --co

        --instance-market-options MarketType=on-demand \
    

        --instance-market-options MarketType=on-deman

        --instance-market-options MarketType=on-de

        --instance-market-options MarketType=on

        --instance-market-options MarketType

        --instance-market-options Market

        --instance-market-options Ma

        --instance-market-optio

        --instance-market-

        --instance-m

        --inst

       
$INSTANCE_COUNT \
        --region 
        --region

        --reg

        -

     

 
$REGION
    
    if [ $? -eq 0 ]; then
        
    

 
echo "Successfully launched $INSTANCE_COUNT instances in $REGION using $TEMPLATE."
    else
        
        
echo "Failed to launch instances in $REGION using $TEMPLATE." >&2
    fi
done



e
echo "All instances launched successfully!"

``
