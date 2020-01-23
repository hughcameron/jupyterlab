
FROM jupyter/pyspark-notebook

ADD environment.yml /tmp/environment.yml
RUN conda env update --name base -f /tmp/environment.yml

ADD https://jdbc.postgresql.org/download/postgresql-42.2.5.jar /usr/local/spark/jars
RUN chmod a+r /usr/local/spark/jars/*

USER root
RUN mkdir /.vscode
COPY settings.json /.vscode/settings.json
RUN chown jovyan:users -R /.vscode

USER $NB_USER

CMD ["start.sh", "jupyter", "lab","--ip='*'", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.disable_check_xsrf=True", "--NotebookApp.token=''", "--notebook-dir=/home/jovyan"]
