FROM jupyter/datascience-notebook:r-4.0.3

# Install Jupyterlab
USER root
RUN pip install --upgrade jupyterlab jupyterlab-git
RUN jupyter lab build
COPY requirements_container.txt .
RUN pip install -r requirements_container.txt
RUN jupyter server extension enable --py jupyterlab_git
RUN pip install nbgitpuller
RUN jupyter serverextension enable --py nbgitpuller --sys-prefix

# Install basic tools
RUN apt-get -y update && \
    apt-get -y install gcc python2.7 python-dev python-setuptools wget ca-certificates \
       # These are necessary for add-apt-respository
       software-properties-common && \

    # Install Git >2.0.1
    add-apt-repository ppa:git-core/ppa && \
    apt-get -y update && \
    apt-get -y install git
