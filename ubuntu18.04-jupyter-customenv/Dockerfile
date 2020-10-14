FROM nvidia/cuda:10.0-runtime-ubuntu18.04
# FROM ubuntu:18.04
MAINTAINER  Rieguass <wangdf@deepblueai.com>

COPY sources.list /etc/apt/
COPY pip.conf /etc/

RUN rm -rf /etc/apt/sources.list.d/*
ARG NB_USER="jovyan"
ARG NB_UID="1000" 
ARG NB_GID="100"

SHELL ["/bin/bash", "-o", "pipefail", "-c"] 

USER root 
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \                                
 && apt-get install -yq --no-install-recommends \   
    wget \                                          
    git \                                          
    bzip2 \                                         
    ca-certificates \                               
    sudo \                                          
    locales \                                       
    fonts-liberation \                              
    run-one \                                       
 && apt-get clean && rm -rf /var/lib/apt/lists/*    

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \ 
    locale-gen                                      

# Configure environment                                                               
ENV CONDA_DIR=/opt/conda \                                                            
    SHELL=/bin/bash \                                                                 
    NB_USER=$NB_USER \                                                                
    NB_UID=$NB_UID \                                                                  
    NB_GID=$NB_GID \                                                                  
    LC_ALL=en_US.UTF-8 \                                                              
    LANG=en_US.UTF-8 \                                                                
    LANGUAGE=en_US.UTF-8                                                              
ENV PATH=$CONDA_DIR/bin:$PATH \                                                       
    HOME=/home/$NB_USER                                                               
                                                                                      
# Copy a script that we will use to correct permissions after running certain commands
COPY fix-permissions /usr/local/bin/fix-permissions                                   
RUN chmod a+rx /usr/local/bin/fix-permissions                                         
                                                                                      
# Enable prompt color in the skeleton .bashrc before creating the default NB_USER     
RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc     
                                                                                      
# and make sure these dirs are writable by the `users` group.    
RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su && \      
    sed -i.bak -e 's/^%admin/#%admin/' /etc/sudoers && \         
    sed -i.bak -e 's/^%sudo/#%sudo/' /etc/sudoers && \           
    useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \          
    mkdir -p $CONDA_DIR && \                                     
    chown $NB_USER:$NB_GID $CONDA_DIR && \                       
    chmod g+w /etc/passwd && \                                   
    fix-permissions $HOME && \                                   
    fix-permissions $CONDA_DIR                                   

RUN echo 'jovyan ALL=NOPASSWD: ALL' >> /etc/sudoers.d/nopasswd

USER $NB_UID
WORKDIR $HOME
ARG PYTHON_VERSION=default

# Setup work directory for backward-compatibility 
RUN mkdir /home/$NB_USER/work && \                
    fix-permissions /home/$NB_USER                

# Install conda as jovyan and check the md5 sum provided on the download site 
ENV MINICONDA_VERSION=4.8.3 \                                                 
    MINICONDA_MD5=751786b92c00b1aeae3f017b781018df \                          
    CONDA_VERSION=4.8.3                                                       

WORKDIR /tmp

RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda3-py37_${MINICONDA_VERSION}-Linux-x86_64.sh && \
    echo "${MINICONDA_MD5} *Miniconda3-py37_${MINICONDA_VERSION}-Linux-x86_64.sh" | md5sum -c - && \
    /bin/bash Miniconda3-py37_${MINICONDA_VERSION}-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-py37_${MINICONDA_VERSION}-Linux-x86_64.sh && \
    echo "conda ${CONDA_VERSION}" >> $CONDA_DIR/conda-meta/pinned && \
    conda config --system --prepend channels conda-forge && \
    conda config --system --set auto_update_conda false && \
    conda config --system --set show_channel_urls true && \
    conda config --system --set channel_priority strict && \
    if [ ! $PYTHON_VERSION = 'default' ]; then conda install --yes python=$PYTHON_VERSION; fi && \
    conda list python | grep '^python ' | tr -s ' ' | cut -d '.' -f 1,2 | sed 's/$/.*/' >> $CONDA_DIR/conda-meta/pinned && \
    conda install --quiet --yes conda && \
    conda install --quiet --yes pip && \
    conda update --all --quiet --yes && \
    conda clean --all -f -y && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Install Tini
RUN conda install --quiet --yes 'tini=0.18.0' && \
    conda list tini | grep tini | tr -s ' ' | cut -d ' ' -f 1,2 >> $CONDA_DIR/conda-meta/pinned && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

RUN conda install --quiet --yes \
    'notebook=6.1.3' \
    'jupyterhub=1.1.0' \
    'jupyterlab=2.2.5' && \
    conda clean --all -f -y && \
    npm cache clean --force && \
    jupyter notebook --generate-config && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

EXPOSE 8888

# Copy local files as late as possible to avoid cache busting
COPY start.sh start-notebook.sh start-singleuser.sh /usr/local/bin/
COPY jupyter_notebook_config.py /etc/jupyter/
# COPY config.py /etc/jupyter/

# Fix permissions on /etc/jupyter as root
USER root
RUN fix-permissions /etc/jupyter/

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID

# RUN jupyter notebook --generate-config -y
ENV JUPYTER_ENABLE_LAB=yes
# Configure container startup
ENTRYPOINT ["tini", "-g", "--"]
CMD ["start-notebook.sh"]
# CMD ["jupyter","lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]

WORKDIR $HOME
