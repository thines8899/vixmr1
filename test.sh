#!/bin/bash

# Khai báo các thông tin về Launch Template cho từng vùng
declare -A LAUNCH_TEMPLATE_NAMES=
  ["us-east-1"]="SpotLaunchTemplate-us-east-1"  # Tên Launch Template ở us-east-1
  ["us-west-2"]="SpotLaunchTemplate-us-west-2"  # Tên Launch Template ở us-west-2
  ["us-east-2"]="SpotLaunchTemplate-us-east-2"  # Tên Launch Template ở eu-north-1


INSTANCE_TYPE="c7a.2xlarge"  # Loại instance
INSTANCE_COUNT=8  # Số lượng VPS muốn tạo trong mỗi vùng

# Lặp qua từng vùng và tạo các VPS
for REGION in "${!LAUNCH_TEMPLATE_NAMES[@]}"; do
  LAUNCH_TEMPLATE_NAME=${LAUNCH_TEMPLATE_NAMES[$REGION]}

  echo "Đang tạo $INSTANCE_COUNT VPS từ Launch Template ($LAUNCH_TEMPLATE_NAME) trong vùng $REGION..."
  
  # Tạo các Spot Instances sử dụng Launch Template trong mỗi vùng
  aws ec2 run-instances \
    --region "$REGION" \
    --launch-template "LaunchTemplateName=$LAUNCH_TEMPLATE_NAME,Version=1" \
    --instance-count "$INSTANCE_COUNT" \
    --instance-market-options "MarketType=spot" \
    --instance-type "$INSTANCE_TYPE" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=VPS-${REGION}}]"

  echo "Hoàn tất khởi tạo $INSTANCE_COUNT VPS trong vùng $REGION."
done

echo "Hoàn tất việc tạo VPS trong tất cả các vùng."
