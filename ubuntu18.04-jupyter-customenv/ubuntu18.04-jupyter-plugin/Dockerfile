FROM ccr.ccs.tencentyun.com/deepblue/ubuntu18.04-jupyter-customenv:latest

RUN sudo apt-get update && \
    sudo apt-get install -yq --no-install-recommends nodejs && \
    sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*


RUN pip install --no-cache-dir jupyter-lsp  python-language-server[all] && \ 
    jupyter labextension install @krassowski/jupyterlab-lsp
