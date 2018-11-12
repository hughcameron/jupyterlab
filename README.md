
# JupyterLab

This container uses [Anaconda](https://hub.docker.com/r/continuumio/anaconda3/) as a base image. Exploratory Data Analysis can be conducted using [Jupyter Lab](https://jupyterlab.readthedocs.io/en/stable/).

# Packages
Extra packages are included based on preference:

- [Summer](https://github.com/hughcameron/summer)
- [psycopg2](http://initd.org/psycopg/)
- [pymysql](https://github.com/PyMySQL/PyMySQL/)
- [regex](https://bitbucket.org/mrabarnett/mrab-regex)
- [matplotlib-venn](https://github.com/konstantint/matplotlib-venn)
- [pyicu](https://github.com/ovalhub/pyicu)
- [flanker](https://github.com/mailgun/flanker)


# Building The Container

`docker-compose build --no-cache`