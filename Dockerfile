# Start from a core stack version
FROM jupyter/all-spark-notebook:latest

# JupyterLab GIT extension: 
RUN jupyter labextension install @jupyterlab/git && \
    pip install jupyterlab-git && \
    jupyter serverextension enable --py --sys-prefix jupyterlab_git

# JupyterLab extensions: 
RUN conda install --quiet --yes -c conda-forge ipywidgets

USER root

ADD https://jdbc.postgresql.org/download/postgresql-42.2.5.jar /usr/local/spark/jars
RUN chmod a+r /usr/local/spark/jars/*

USER $NB_UID

RUN jupyter labextension install \
    @jupyterlab/github \
    @jupyterlab/vega2-extension \
    # @jpmorganchase/perspective-jupyterlab \
    beakerx-jupyterlab \
    @jupyterlab/toc \
    bqplot \
    jupyterlab-kernelspy \
    qgrid \
    knowledgelab

# various further data science libraries
RUN conda install \
    altair \
    boto3 \
    botocore \
    fiona \
    folium \
    geopandas \
    geopy \
    ipywidgets \
    matplotlib-venn \
    nameparser \
    nodejs \
    pandasql \
    phonenumbers \
    psycopg2 \
    pyicu \
    pymysql \
    pyproj \
    regex \
    rtree \
    shapely \
    s3fs \
    tqdm \
    vega_datasets \
    xmltodict

RUN pip install \
    ballpark \
    chartify \
    # chromedriver_installer \
    createsend \
    flanker \
    rgeocoder \
    git+https://github.com/hughcameron/summer.git --upgrade

# cleanup: 
RUN npm cache clean --force && \
    rm -rf /opt/conda/share/jupyter/lab/staging && \
    rm -rf /home/jovyan/.cache/yarn && \
    fix-permissions /opt/conda && \
    fix-permissions /home/jovyan

# From: https://github.com/codercom/code-server/blob/master/Dockerfile

FROM node:8.15.0

# Install VS Code's deps. These are the only two it seems we need.
RUN apt-get update && apt-get install -y \
	libxkbfile-dev \
	libsecret-1-dev

# Ensure latest yarn.
RUN npm install -g yarn@1.13

WORKDIR /src
COPY . .

# In the future, we can use https://github.com/yarnpkg/rfcs/pull/53 to make yarn use the node_modules
# directly which should be fast as it is slow because it populates its own cache every time.
RUN yarn && yarn task build:server:binary

# We deploy with ubuntu so that devs have a familiar environment.
FROM ubuntu:18.10
WORKDIR /root/project
COPY --from=0 /src/packages/server/cli-linux-x64 /usr/local/bin/code-server
EXPOSE 8443

RUN apt-get update && apt-get install -y \
	openssl \
	net-tools \
	git \
	locales
RUN locale-gen en_US.UTF-8
# We unfortunately cannot use update-locale because docker will not use the env variables
# configured in /etc/default/locale so we need to set it manually.
ENV LANG=en_US.UTF-8
ENTRYPOINT ["code-server"]