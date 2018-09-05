FROM continuumio/anaconda3
RUN conda config --add channels conda-forge

RUN conda install \
    matplotlib-venn \
    psycopg2 \
    pandasql \
    pyicu \
    pymysql \
    regex

RUN pip install \
    flanker && \
    git+https://github.com/hughcameron/ikon.git --upgrade

WORKDIR /workspace
CMD jupyter-lab --no-browser \
  --port=8080 --ip=0.0.0.0 --allow-root