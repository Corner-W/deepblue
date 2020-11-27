（1）添加 apt-key
curl -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - &&
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) 

（2）添加阿里云仓库
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

（3）更新库
apt-get update

（4）查看当前库对应的 nvidia-docker2 可用的版本
apt-cache madison nvidia-docker2

（5）安装 nvidia-docker2
apt-get install -y nvidia-docker2  && pkill -SIGHUP dockerd

（6）查看 nvidia-docker 版本
nvidia-docker --version