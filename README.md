# jupyterhub-dockerspawner    

## Install Docker
```
sudo apt-get -y update
sudo apt-get -y install     apt-transport-https     ca-certificates     curl     gnupg-agent     software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io
sudo groupadd docker
sudo usermod -aG docker $USER
```

## Install Miniconda
```
sudo apt-get -y install wget
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh 
```

## Increase Boot Disk Size (debian)
```
sudo apt install -y cloud-utils         # Debian jessie
sudo apt install -y cloud-guest-utils   # Debian stretch, Ubuntu
sudo growpart /dev/sda 1
sudo resize2fs /dev/sda1  
```

## Install JupyterHub and proxy
```
conda install -c conda-forge jupyterhub conda jupyterlab
conda install notebook
conda install -c conda-forge dockerspawner
pip install jupyterhub-dummyauthenticator
```

## Install Jupyter as a service (using miniconda)
```
sudo useradd jupyter
sudo groupadd jupyterhub
sudo usermod jupyter -G jupyterhub
sudo mkdir /etc/jupyterhub
sudo chown jupyter /etc/jupyterhub
sudo cp jupyterhub_config.py /etc/jupyterhub/
sudo cp runJupyter.sh /etc/jupyterhub/
vi jupyterhub.service
```

## Build the Docker image 
dockerspawner uses an image from the docker stack. Use the example provided in this repo.
```
docker build -t snamburi3/datascience-notebook .
```

## Add the following to the jupyterhub.service
```
[Unit]
Description=Jupyterhub
After=syslog.target network-online.target

[Service]
Type=simple
User=jupyter
ExecStart=/etc/jupyterhub/runJupyter.sh
WorkingDirectory=/etc/jupyterhub
Restart=on-failure
RestartSec=1min
TimeoutSec=5min

[Install]
WantedBy=multi-user.target
```

## Install the Jupyterhub service
```
sudo cp jupyterhub.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl start jupyterhub.service
sudo systemctl status jupyterhub.service
sudo systemctl restart jupyterhub.service
```
  
## logs for jupyterhub are written here
```
vim /home/jupyter/jupyterhub.log 
vim /var/log/syslog 
```

## change the permission of the scripts
```
sudo chmod a+x /etc/jupyterhub/runJupyter.sh 
```
