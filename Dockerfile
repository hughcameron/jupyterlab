
FROM jupyter/pyspark-notebook

ADD environment.yml /tmp/environment.yml
RUN conda env update --name base -f /tmp/environment.yml
RUN conda update --all -y

USER root

RUN apt-get update && apt-get install -y tmux htop vim alien

RUN mkdir /.vscode
COPY settings.json /.vscode/settings.json
RUN chown jovyan:users -R /.vscode

RUN wget https://download.dremio.com/odbc-driver/dremio-odbc-LATEST.x86_64.rpm
RUN sudo alien -i dremio-odbc-LATEST.x86_64.rpm

ADD https://jdbc.postgresql.org/download/postgresql-42.2.5.jar /usr/local/spark/jars
RUN chmod a+r /usr/local/spark/jars/*

USER $NB_USER

CMD ["start.sh", "jupyter", "lab","--ip='*'", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.disable_check_xsrf=True", "--NotebookApp.token=''", "--notebook-dir=/home/jovyan"]
