#!/bin/bash
# Lấy danh sách các dự án
PROJECTS=$(gcloud projects list --format="value(projectId)")
# Kiểm tra danh sách các dự án
echo "Projects: $PROJECTS"
# Danh sách các vùng
ZONES=(
  "us-east4-a"
  "us-east1-b"
)

# Lặp qua từng dự án
for PROJECT in $PROJECTS; do
  echo "Checking project: $PROJECT"
  # Thiết lập dự án hiện tại
  gcloud config set project "$PROJECT"
  
  # Lặp qua từng vùng
  for ZONE in "${ZONES[@]}"; do
    echo "  Checking zone: $ZONE"
    # Lấy danh sách các máy ảo trong vùng
    INSTANCES=$(gcloud compute instances list --zones="$ZONE" --format="value(name,status)")
    echo "INSTANCES: $INSTANCES"
    if [ -z "$INSTANCES" ]; then
      echo "    No instances found in $ZONE for $PROJECT"
    else
      echo "    Instances in $ZONE for $PROJECT:"
      while IFS= read -r INSTANCE; do
        INSTANCE_NAME=$(echo "$INSTANCE" | awk '{print $1}')
        INSTANCE_STATUS=$(echo "$INSTANCE" | awk '{print $2}')
        
        if [ "$INSTANCE_STATUS" != "RUNNING" ]; then
          echo "      Instance $INSTANCE_NAME is $INSTANCE_STATUS. Starting it now..."
          gcloud compute instances start "$INSTANCE_NAME" --zone="$ZONE"
        else
          echo "      Instance $INSTANCE_NAME is already running."
        fi
      done <<< "$INSTANCES"
    fi
  done
done
