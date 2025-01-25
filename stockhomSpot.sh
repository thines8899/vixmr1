#!/bin/bash

# Định nghĩa Launch Template cho từng vùng
declare -A REGION_TEMPLATES
REGION_TEMPLATES["us-east-1"]="SpotLaunchTemplate-us-east-1"
REGION_TEMPLATES["us-west-2"]="SpotLaunchTemplate-us-west-2"
REGION_TEMPLATES["eu-north-1"]="SpotLaunchTemplate-eu-north-1"

# Số lượng instances cần tạo ở mỗi vùng
INSTANCE_COUNT=8

# Vòng lặp qua từng vùng và Launch Template để khởi chạy instances
for REGION in "${!REGION_TEMPLATES[@]}"; do
    TEMPLATE=${REGION_TEMPLATES[$REGION]}
    echo "Launching $INSTANCE_COUNT instances in $REGION using Launch Template $TEMPLATE..."
    
    aws ec2 run-instances \
        --launch-template LaunchTemplateName=$TEMPLATE,Version=1 \
        --instance-market-options MarketType=spot \
        --count $INSTANCE_COUNT \
        --region $REGION
    
    if [ $? -eq 0 ]; then
        echo "Successfully launched $INSTANCE_COUNT instances in $REGION."
    else
        echo "Failed to launch instances in $REGION." >&2
    fi
done

