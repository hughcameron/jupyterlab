
FROM daskdev/dask-notebook
ADD environment.yml /tmp/environment.yml
RUN conda env update --name base -f /tmp/environment.yml
WORKDIR /home/jovyan/home
CMD ["start.sh", "jupyter", "lab","--ip='*'", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.disable_check_xsrf=True", "--NotebookApp.token=''", "--notebook-dir=/home/team"]
