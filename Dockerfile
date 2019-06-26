# Start from a core stack version
FROM jupyter/all-spark-notebook:latest

# JupyterLab GIT extension: 
RUN jupyter labextension install @jupyterlab/git && \
    pip install jupyterlab_code_formatter jupyterlab-git && \
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
    @finos/perspective-jupyterlab \
    @ryantam626/jupyterlab_code_formatter \
    # beakerx-jupyterlab \
    @jupyterlab/toc
    # bqplot \
    # @jupyterlab-kernelspy
    # qgrid \
    # knowledgelab

RUN jupyter serverextension enable --py jupyterlab_code_formatter

# various further data science libraries
RUN conda install \
    aiofiles \
    aiohttp \
    altair \
    asyncpg \
    boto3 \
    botocore \
    fiona \
    folium \
    geopandas \
    geopy \
    ipywidgets \
    # matplotlib-venn \
    nameparser \
    nodejs \
    pandasql \
    phonenumbers \
    psycopg2 \
    pyicu \
    pymapd \
    pymysql \
    pyproj \
    regex \
    rtree \
    s3fs \
    shapely \
    tqdm \
    ujson \
    vega_datasets \
    xmltodict

RUN pip install \
    asyncio \
    ballpark \
    flanker \
    pandas_bokeh \
    perspective-python \
    git+https://github.com/hughcameron/summer.git --upgrade