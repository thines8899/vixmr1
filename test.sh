#!/bin/bash

# Khai báo các thông tin về Launch Template cho từng vùng
REGION_TEMPLATES=("us-east-1:LaunchTemplate-us-east-1" "us-west-2:LaunchTemplate-us-west-2" "us-east-2:LaunchTemplate-us-east-2")

INSTANCE_TYPE="c7a.2xlarge"  # Loại instance
INSTANCE_COUNT=8  # Số lượng VPS muốn tạo trong mỗi vùng

# Lặp qua từng vùng và tạo các VPS
for REGION_TEMPLATE in "${REGION_TEMPLATES[@]}"; do
  # Tách vùng và tên Launch Template từ array
  REGION=$(echo "$REGION_TEMPLATE" | cut -d':' -f1)
  LAUNCH_TEMPLATE_NAME=$(echo "$REGION_TEMPLATE" | cut -d':' -f2)

  echo "Đang tạo $INSTANCE_COUNT VPS từ Launch Template ($LAUNCH_TEMPLATE_NAME) trong vùng $REGION..."
  
  # Tạo các Spot Instances sử dụng Launch Template trong mỗi vùng
  aws ec2 run-instances \
    --region "$REGION" \
    --launch-template "LaunchTemplateName=$LAUNCH_TEMPLATE_NAME,Version=1" \
    --instance-market-options "MarketType=spot" \
    --instance-type "$INSTANCE_TYPE" \
    --instance-count "$INSTANCE_COUNT" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=VPS-${REGION}}]"

  # Kiểm tra trạng thái lệnh vừa chạy
  if [ $? -ne 0 ]; then
    echo "Lỗi khi tạo VPS trong vùng $REGION. Vui lòng kiểm tra lại."
    exit 1
  fi

  echo "Hoàn tất khởi tạo $INSTANCE_COUNT VPS trong vùng $REGION."
done

echo "Hoàn tất việc tạo VPS trong tất cả các vùng."
