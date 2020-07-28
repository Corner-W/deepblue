* sudo swapoff -a  关闭swap

* 设置仓库地址

```yml
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | sudo apt-key add -

    sudo bash -c 'cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
    deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
    EOF'

sudo apt-get update
sudo apt-get install -y kubectl=1.15.12-00  kubeadm=1.15.12-00  kubelet=1.15.12-00
```

* 启动kubelet

sudo systemctl enable kubelet && sudo systemctl start kubelet


* 设置iptables

```shell
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl --system



```

* 查看&下载需要的images

```shell

kubeadm config images list

#!/bin/bash

images=(
    kube-apiserver:v1.15.12
    kube-controller-manager:v1.15.12
    kube-scheduler:v1.15.12
    kube-proxy:v1.15.12
    pause:3.1
    etcd:3.3.10
    coredns:1.3.1
)

for imageName in ${images[@]} ; do
    docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
    docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName k8s.gcr.io/$imageName
done
```


* 初始化集群
```shell
kubeadm init
```

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

kubectl taint nodes --all node-role.kubernetes.io/master-


* 集群证书管理
```shell
sudo kubeadm alpha certs check-expiration

sudo kubeadm alpha certs renew all


```