#!/bin/bash

# Định nghĩa Launch Template cho từng vùng
declare -A REGION_TEMPLATES
REGION_TEMPLATES["us-east-1"]="us-east-launch-template"
REGION_TEMPLATES["us-west-2"]="us-west-launch-template"
REGION_TEMPLATES["eu-north-1"]="eu-north-launch-template"

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
