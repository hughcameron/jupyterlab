
FROM daskdev/dask-notebook

ADD environment.yml /tmp/environment.yml
RUN conda env update --name base -f /tmp/environment.yml

USER root
RUN mkdir /.vscode
COPY settings.json /.vscode/settings.json
RUN chown jovyan:users -R /.vscode

USER $NB_USER
RUN conda init bash
RUN conda activate base

CMD ["start.sh", "jupyter", "lab","--ip='*'", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.disable_check_xsrf=True", "--NotebookApp.token=''", "--notebook-dir=/home/jovyan"]
