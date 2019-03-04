# Start from a core stack version
FROM jupyter/all-spark-notebook:latest

# JupyterLab GIT extension: 
RUN jupyter labextension install @jupyterlab/git && \
    pip install jupyterlab-git && \
    jupyter serverextension enable --py --sys-prefix jupyterlab_git

# other python libraries and JupyterLab extensions: 
RUN pip install ipywidgets && \
    pip install psycopg2-binary && \
    pip install --upgrade google-cloud-bigquery && \
    pip install -e git+https://github.com/SohierDane/BigQuery_Helper#egg=bq_helper && \
    /opt/conda/bin/conda/bin/conda install --quiet --yes -c conda-forge ipywidgets && \
    jupyter labextension install @jupyterlab/github && \
    jupyter labextension install @jupyterlab/vega2-extension && \
    jupyter labextension install @jpmorganchase/perspective-jupyterlab && \
    jupyter labextension install beakerx-jupyterlab && \
    jupyter labextension install @jupyterlab/toc && \
    jupyter labextension install bqplot && \
    jupyter labextension install jupyterlab-kernelspy && \
    jupyter labextension install qgrid && \
    jupyter labextension install knowledgelab

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
    rm -rf /opt/conda/bin/conda/share/jupyter/lab/staging && \
    rm -rf /home/jovyan/.cache/yarn && \
    fix-permissions /opt/conda/bin/conda && \
    fix-permissions /home/jovyan
