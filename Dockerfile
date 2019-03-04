# Start from a core stack version
FROM jupyter/all-spark-notebook:latest

# JupyterLab GIT extension: 
RUN jupyter labextension install @jupyterlab/git && \
    pip install jupyterlab-git && \
    jupyter serverextension enable --py --sys-prefix jupyterlab_git

# JupyterLab extensions: 
RUN conda install --quiet --yes -c conda-forge ipywidgets

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
