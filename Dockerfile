FROM nvidia/cuda:9.0-cudnn7-runtime

ARG PYTHON_VERSION=3.6
ARG CONDA_VERSION=3
ARG CONDA_PY_VERSION=4.5.11

# Installation of some libraries / RUN some commands on the base image
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y python3-pip python3-dev wget \
    bzip2 libopenblas-dev pbzip2 libgl1-mesa-glx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
	
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh

RUN bash ~/miniconda.sh -b -p /conda/miniconda
RUN rm -f ~/miniconda.sh

ENV PATH /conda/miniconda/bin:$PATH
RUN eval "$(/conda/miniconda/bin shell.bash hook)"

RUN conda install -c anaconda ipython -y && conda install -c anaconda tensorflow-gpu -y && conda install scikit-learn -y && conda install tqdm -y && conda install pandas -y && conda install keras -y && conda install ffmpeg -y && conda install intel-openmp=2019.4=243 -y

RUN pip install torch torchsummary imgaug nibabel pydicom pydicom
RUN apt-get update -y && apt-get install libglib2.0-0 -y

RUN groupadd -g 1000 ubuntu
RUN useradd -u 1000 -ms /bin/bash -g ubuntu ubuntu

RUN conda create --name sirona-ml -y
RUN activate sirona-ml