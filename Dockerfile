FROM continuumio/anaconda3

RUN conda config --add channels conda-forge --force

# RUN apt-get update

RUN conda install \
    altair \
    boto3 \
    botocore \
    fiona \
    folium \
    geopandas \
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
    vega_datasets \
    xmltodict

# Geopandas fix from https://github.com/Kaggle/docker-python/blob/master/Dockerfile#L306 & https://www.kaggle.com/product-feedback/60653#post353813

RUN conda uninstall -y fiona geopandas
RUN pip uninstall -y fiona geopandas
RUN pip install fiona geopandas

RUN pip install \
    ballpark \
    chartify \
    # chromedriver_installer \
    createsend \
    flanker \
    git+https://github.com/hughcameron/summer.git --upgrade

# RUN jupyter lab clean

# RUN jupyter labextension install \ 
# jupyter-matplotlib \
# jupyterlab_voyager \
# qgrid

# RUN jupyter lab build

WORKDIR /workspace
CMD jupyter-lab --no-browser \
    --port=8080 --ip=0.0.0.0 --allow-root