FROM jupyter/pyspark-notebook:latest

RUN conda config --add channels conda-forge --force

# RUN apt-get update

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
    qgrid \
    regex \
    rtree \
    shapely \
    s3fs \
    tqdm \
    vega_datasets \
    xmltodict

# Geopandas fix from https://github.com/Kaggle/docker-python/blob/master/Dockerfile#L306 & https://www.kaggle.com/product-feedback/60653#post353813

# RUN conda uninstall -y fiona geopandas
# RUN pip uninstall -y fiona geopandas
# RUN pip install fiona geopandas

RUN pip install \
    ballpark \
    chartify \
    # chromedriver_installer \
    createsend \
    flanker \
    rgeocoder \
    git+https://github.com/hughcameron/summer.git --upgrade

# Install iRuby as per https://github.com/SciRuby/iruby
# https://github.com/igorferst/iruby-dockerized/blob/master/Dockerfile

# Need these values for setup
USER root
WORKDIR /tmp/czmq

# https://github.com/SciRuby/iruby#preparing-dependencies-on-1604
RUN apt-get update
RUN apt-get install -y libtool libffi-dev ruby ruby-dev make
RUN apt-get install -y git libzmq-dev autoconf pkg-config
RUN git clone https://github.com/zeromq/czmq /tmp/czmq
RUN ./autogen.sh && ./configure && sudo make && sudo make install

RUN gem install cztop iruby
RUN iruby register

# Install additional gems here
RUN gem install rspec

# Reset user and work dir
USER jovyan
WORKDIR /home/jovyan