FROM continuumio/anaconda3
RUN conda config --add channels conda-forge

RUN conda install \
    altair \
    matplotlib-venn \
    psycopg2 \
    pandasql \
    pyicu \
    pymysql \
    qgrid \
    regex \
    seaborn==0.9

RUN pip install \
    flanker \
    validators \
    git+https://github.com/hughcameron/ikon.git --upgrade

WORKDIR /workspace
CMD jupyter-lab --no-browser \
  --port=8080 --ip=0.0.0.0 --allow-root