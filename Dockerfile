
FROM jupyter/pyspark-notebook

ADD environment.yml /tmp/environment.yml
RUN conda env update --name base -f /tmp/environment.yml
RUN conda update --all -y

USER root

RUN apt-get update && apt-get install -y tmux htop vim git

RUN jupyter labextension install \
    @jupyterlab/shortcutui \
    @jupyterlab/toc \
    jupyterlab-execute-time \
    jupyterlab-tailwind-theme \
    jupyterlab_templates \
    jupyterlab-s3-browser \
    @krassowski/jupyterlab-lsp \
    @ryantam626/jupyterlab_code_formatter
    # @finos/perspective-jupyterlab

RUN jupyter serverextension enable --py jupyterlab_git jupyterlab_templates
RUN jupyter serverextension enable --py jupyterlab_code_formatter --sys-prefix

RUN jupyter lab build

# RUN apt-get install software-properties-common
# RUN add-apt-repository ppa:bashtop-monitor/bashtop
# RUN apt install bashtop

RUN mkdir /.vscode
COPY settings/theme.json /.vscode/settings.json
RUN chown jovyan:users -R /.vscode

ADD https://jdbc.postgresql.org/download/postgresql-42.2.5.jar /usr/local/spark/jars
RUN chmod a+r /usr/local/spark/jars/*

COPY settings/shortcuts.json /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/shortcuts-extension/shortcuts.jupyterlab-settings
COPY settings/theme.json /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings
COPY settings/terminal.json /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/terminal-extension/plugin.jupyterlab-settings
COPY settings/notebook.json /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/tracker.jupyterlab-settings
RUN chmod -R 777 /home/jovyan/

USER $NB_USER

CMD ["start.sh", "jupyter", "lab","--ip='*'", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.disable_check_xsrf=True", "--NotebookApp.token=''", "--notebook-dir=/home/jovyan"]
