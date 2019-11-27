# Start from a core stack version
FROM continuumio/anaconda3:latest

# JupyterLab GIT extension: 
# RUN jupyter labextension install @jupyterlab/git && \
#     pip install jupyterlab-git && \
#     jupyter serverextension enable --py --sys-prefix jupyterlab_git

# JupyterLab extensions: 
RUN conda install --quiet --yes -c conda-forge ipywidgets
RUN conda config --add channels conda-forge

RUN mkdir /.vscode 
COPY settings.json /.vscode/settings.json
# RUN chown jovyan:users -R /.vscode

# ADD https://jdbc.postgresql.org/download/postgresql-42.2.5.jar /usr/local/spark/jars
# RUN chmod a+r /usr/local/spark/jars/*

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
    hvplot \
    ipywidgets \
    matplotlib-venn \
    nameparser \
    nodejs \
    pandasql \
    phonenumbers \
    psycopg2 \
    # pyicu \
    pylint \
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
    xmltodict \
    yapf

RUN jupyter labextension install \
    # @jupyterlab/github \
    # @pyviz/jupyterlab_pyviz \
    dask-labextension

RUN pip install \
    asyncio \
    ballpark \
    flanker \
    pandas_bokeh
    # perspective-python \
    # git+https://github.com/hughcameron/summer.git --upgrade

WORKDIR /workspace
CMD jupyter-lab --no-browser \
    --port=8080 --ip=0.0.0.0 --allow-root