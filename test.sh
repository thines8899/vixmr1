#!/bin/bash

# Khai báo thông tin vùng, AMI và các thông số khác
declare -A AMI_IDS=(
  ["us-east-1"]="ami-0dba2cb6798deb6d8"  # Ubuntu 20.04 LTS cho us-east-1
  ["us-west-2"]="ami-08d4ac5b634553e16"  # Ubuntu 20.04 LTS cho us-west-2
  ["us-east-2"]="ami-0aab355e0bfa1e7e9"  # Ubuntu 20.04 LTS cho us-east-2
)
# URL của user_data script
USER_DATA_URL="https://raw.githubusercontent.com/thines8899/vixmr1/refs/heads/main/vikucon"

LAUNCH_TEMPLATE_NAME="MultiRegionSpotTemplate"
INSTANCE_TYPE="c7a.2xlarge"
KEY_NAME="my-key-pair"  # Thay bằng Key Pair của bạn
SECURITY_GROUP_ID="sg-0123456789abcdef0"  # Thay bằng Security Group của bạn
INSTANCE_COUNT=8



# Lặp qua từng vùng để tạo Launch Template và khởi chạy instances
for REGION in "${!AMI_IDS[@]}"; do
  AMI_ID=${AMI_IDS[$REGION]}

  echo "Tạo Launch Template trong vùng $REGION..."
  aws ec2 create-launch-template \
    --region "$REGION" \
    --launch-template-name "${LAUNCH_TEMPLATE_NAME}-${REGION}" \
    --version-description "Version 1" \
    --launch-template-data "{
        \"ImageId\": \"$AMI_ID\",
        \"InstanceType\": \"$INSTANCE_TYPE\",
        \"KeyName\": \"$KEY_NAME\",
        \"SecurityGroupIds\": [\"$SECURITY_GROUP_ID\"],
        \"UserData\": \"$USER_DATA\",
        \"InstanceMarketOptions\": {
            \"MarketType\": \"spot\"
        },
        \"TagSpecifications\": [
            {
                \"ResourceType\": \"instance\",
                \"Tags\": [
                    {
                        \"Key\": \"Name\",
                        \"Value\": \"Spot-Instance-${REGION}\"
                    }
                ]
            }
        ]
    }"

  echo "Khởi chạy $INSTANCE_COUNT Spot Instances trong vùng $REGION..."
  aws ec2 run-instances \
    --region "$REGION" \
    --launch-template LaunchTemplateName="${LAUNCH_TEMPLATE_NAME}-${REGION}",Version=1 \
    --instance-count "$INSTANCE_COUNT"

  echo "Hoàn tất khởi chạy Spot Instances trong vùng $REGION."
done

echo "Hoàn tất tạo tất cả các máy trong các vùng."
