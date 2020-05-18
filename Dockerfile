
FROM jupyter/pyspark-notebook

USER root

RUN apt-get update && apt-get install -y tmux htop vim git cmake

COPY environment.yml /tmp/environment.yml
RUN conda env update --name base -f /tmp/environment.yml
RUN conda update --all -y

# # Install boost perspective after environment is setup
# # Reference approach at: https://github.com/finos/perspective/blob/master/docker/python3/official/Dockerfile
# RUN wget https://dl.bintray.com/boostorg/release/1.71.0/source/boost_1_71_0.tar.gz >/dev/null 2>&1
# RUN tar xfz boost_1_71_0.tar.gz
# # https://github.com/boostorg/build/issues/468
# RUN cd boost_1_71_0 && ./bootstrap.sh
# RUN cd boost_1_71_0 && ./b2 -j8 --with-program_options --with-filesystem --with-system install
RUN conda install pyarrow==0.15.1 -y
RUN pip install perspective-python


RUN jupyter labextension install \
    @jupyterlab/shortcutui \
    @jupyterlab/toc \
    jupyterlab-execute-time \
    jupyterlab-tailwind-theme \
    jupyterlab_templates \
    jupyterlab-s3-browser \
    @krassowski/jupyterlab-lsp \
    @ryantam626/jupyterlab_code_formatter \
    @finos/perspective-jupyterlab

# Increase the cell width set by the Tailwind theme
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN find . | grep jupyterlab-tailwind-theme/style/index.css |  xargs -i sed -i 's/max-width: 1000px/max-width: 1200px/g' {}

RUN jupyter serverextension enable --py jupyterlab_git jupyterlab_templates
RUN jupyter serverextension enable --py jupyterlab_code_formatter --sys-prefix

RUN jupyter lab build

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
