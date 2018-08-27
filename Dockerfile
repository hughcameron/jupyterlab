FROM continuumio/anaconda3
RUN conda config --add channels conda-forge && \
    conda install psycopg2 pymysql regex matplotlib-venn pyicu && \
    pip install flanker && \
    pip install git+https://github.com/hughcameron/ikon.git --upgrade
WORKDIR /workspace
CMD jupyter-lab --no-browser \
  --port=8000 --ip=0.0.0.0 --allow-root