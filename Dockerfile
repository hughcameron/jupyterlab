
FROM jupyter/pyspark-notebook


## CONDA ENVIRONMENT ##
COPY environment.yml /tmp/environment.yml
RUN conda env update --name base -f /tmp/environment.yml
RUN conda update --all -y


## LINUX PACKAGES ##
USER root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && apt-get install -y tmux htop vim git


## INSTALLING PERSPECTIVE ##
# An awesome package with special needs: # https://github.com/finos/perspective
# The trick is to install cmake & boost after the conda environment is setup.
# Using approach from: https://github.com/finos/perspective/blob/master/docker/python3/official/Dockerfile

# RUN wget https://cmake.org/files/v3.15/cmake-3.15.4-Linux-x86_64.sh -q
# RUN mkdir /opt/cmake
# RUN printf "y\nn\n" | sh cmake-3.15.4-Linux-x86_64.sh --prefix=/opt/cmake > /dev/null
# RUN rm -rf cmake*.sh /opt/cmake/doc /opt/cmake/bin/cmake-gui /opt/cmake/bin/ccmake /opt/cmake/bin/cpack
# RUN ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake
# RUN ln -s /opt/cmake/bin/ctest /usr/local/bin/ctest

# RUN wget https://dl.bintray.com/boostorg/release/1.71.0/source/boost_1_71_0.tar.gz >/dev/null 2>&1
# RUN tar xfz boost_1_71_0.tar.gz
# RUN cd boost_1_71_0 && ./bootstrap.sh
# RUN cd boost_1_71_0 && ./b2 -j8 --with-program_options --with-filesystem --with-system install
# RUN rm -rf boost_1_71_0.tar.gz boost_1_71_0

# RUN conda install pyarrow==0.15.1 -y
# RUN pip install perspective-python


## JUPYTERLAB EXTENSIONS ##
RUN jupyter labextension install \
    @jupyterlab/shortcutui \
    @jupyterlab/toc \
    jupyterlab_templates \
    jupyterlab-execute-time \
    jupyterlab-plotly@4.8.0 \
    jupyterlab-s3-browser \
    jupyterlab-tailwind-theme \
    # @krassowski/jupyterlab-lsp \
    @ryantam626/jupyterlab_code_formatter \
    # @finos/perspective-jupyterlab \
    plotlywidget@4.8.0

# Increase the cell width set by the Tailwind theme
RUN find . | grep jupyterlab-tailwind-theme/style/index.css |  xargs -i sed -i 's/max-width: 1000px/max-width: 1200px/g' {}

RUN jupyter serverextension enable --py jupyterlab_code_formatter --sys-prefix

RUN jupyter lab build


## VS CODE SETTINGS ##
RUN mkdir /.vscode
COPY settings/theme.json /.vscode/settings.json
RUN chown jovyan:users -R /.vscode


## S3 JAR FOR SPARK##
ADD https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.2.0/hadoop-aws-3.2.0.jar $SPARK_HOME/jars

## POSTGRES JDBC FOR SPARK ##
ADD https://jdbc.postgresql.org/download/postgresql-42.2.5.jar $SPARK_HOME/jars


## GRAPHFRAMES FOR SPARK ##
ENV GRAPHFRAMES_VERSION=0.8.1 \
  SPARK_VERSION=3.0 \
  SCALA_VERSION=2.12
ENV GRAPHFRAMES_PACKAGE=${GRAPHFRAMES_VERSION}-spark${SPARK_VERSION}-s_${SCALA_VERSION}

RUN ${SPARK_HOME}/bin/pyspark --packages graphframes:graphframes:${GRAPHFRAMES_PACKAGE}
RUN wget http://dl.bintray.com/spark-packages/maven/graphframes/graphframes/${GRAPHFRAMES_PACKAGE}/graphframes-${GRAPHFRAMES_PACKAGE}.jar -qO ${SPARK_HOME}/jars/graphframes.jar

RUN chmod a+r $SPARK_HOME/jars/*


## PERSIST JUPYTERLAB SETTINGS ##
COPY settings/shortcuts.json /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/shortcuts-extension/shortcuts.jupyterlab-settings
COPY settings/theme.json /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings
COPY settings/terminal.json /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/terminal-extension/plugin.jupyterlab-settings
COPY settings/notebook.json /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/tracker.jupyterlab-settings
RUN chmod -R 777 /home/jovyan/


## START SERVER AS JOVYAN ##
USER $NB_USER
CMD ["start.sh", "jupyter", "lab","--ip='*'", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.disable_check_xsrf=True", "--NotebookApp.token=''", "--notebook-dir=/home/jovyan"]
