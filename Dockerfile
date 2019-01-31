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

RUN apt install libtool libffi-dev ruby ruby-dev make
RUN apt install libzmq3-dev libczmq-dev

RUN gem install \cztop
RUN gem install iruby --pre
RUN iruby register --force

# WORKDIR /workspace
# CMD jupyter-lab --no-browser \
#     --port=8080 --ip=0.0.0.0 --allow-root