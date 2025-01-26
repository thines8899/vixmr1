#!/bin/bash

# Khai báo thông tin vùng và Launch Template
declare -A LAUNCH_TEMPLATE_NAMES=(
  ["us-east-1"]="SpotLaunchTemplate-us-east-1"  # Thay bằng tên Launch Template ở us-east-1
  ["us-west-2"]="SpotLaunchTemplate-us-west-2"  # Thay bằng tên Launch Template ở us-west-2
  ["us-east-2"]="SpotLaunchTemplate-us-east-2"  # Thay bằng tên Launch Template ở us-east-2
)

INSTANCE_COUNT=8  # Số lượng Spot Instances muốn khởi chạy trong mỗi vùng

# Lặp qua từng vùng để khởi chạy Spot Instances từ Launch Template
for REGION in "${!LAUNCH_TEMPLATE_NAMES[@]}"; do
  LAUNCH_TEMPLATE_NAME=${LAUNCH_TEMPLATE_NAMES[$REGION]}

  echo "Khởi chạy $INSTANCE_COUNT Spot Instances từ Launch Template ($LAUNCH_TEMPLATE_NAME) trong vùng $REGION..."
  aws ec2 run-instances \
    --region "$REGION" \
    --launch-template LaunchTemplateName="$LAUNCH_TEMPLATE_NAME",Version=1 \
    --instance-count "$INSTANCE_COUNT" \
    --instance-market-options "MarketType=spot"

  echo "Hoàn tất khởi chạy Spot Instances trong vùng $REGION."
done

echo "Hoàn tất khởi chạy Spot Instances trong tất cả các vùng."
