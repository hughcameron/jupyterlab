
FROM jupyter/pyspark-notebook

ADD environment.yml /tmp/environment.yml
RUN conda env update --name base -f /tmp/environment.yml
RUN conda update --all -y

USER root

RUN apt-get update && apt-get install -y tmux htop vim

RUN jupyter labextension install \
    @jupyterlab/shortcutui \
    @jupyterlab/toc \
    jupyterlab-system-monitor \
    jupyterlab-topbar-extension \
    jupyterlab-tailwind-theme \
    jupyterlab_spark

RUN jupyter lab build

RUN mkdir /.vscode
COPY vscode_settings.json /.vscode/settings.json
RUN chown jovyan:users -R /.vscode

ADD https://jdbc.postgresql.org/download/postgresql-42.2.5.jar /usr/local/spark/jars
RUN chmod a+r /usr/local/spark/jars/*

USER $NB_USER

CMD ["start.sh", "jupyter", "lab","--ip='*'", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.disable_check_xsrf=True", "--NotebookApp.token=''", "--notebook-dir=/home/jovyan"]
