FROM 10.16.32.59:1180/wdf/ubuntu16.04-project-autocv:latest
MAINTAINER Rieguass <wangdf@deepblueai.com>

ARG MINICONDA_INSTALLER="Miniconda3-4.5.11-Linux-x86_64.sh"

USER root

# COPY pip.conf /etc/

ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH

RUN mkdir -p $CONDA_DIR && \
    chown $NB_UID:$NB_GID $CONDA_DIR


# USER $NB_UID

COPY --chown=admin:admin $MINICONDA_INSTALLER /tmp
RUN cd /tmp && \
    /bin/bash $MINICONDA_INSTALLER -f -b -p $CONDA_DIR

# RUN conda config --add channels http://mirrors.aliyun.com/pypi/simple && \
#     conda config --add channels https://pypi.tuna.tsinghua.edu.cn/simple && \
#    conda config --set show_channel_urls yes
# RUN conda install --quiet --yes 'python=3.7'
# RUN conda install --yes  pytorch torchvision cudatoolkit=10.0 -c https://pypi.tuna.tsinghua.edu.cn/simple
# RUN conda clean -tipsy && \
#     rm $MINICONDA_INSTALLER

# RUN pip install pyspark==2.3.2 Numpy
