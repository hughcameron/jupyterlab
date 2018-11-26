
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


# Notbook Password

Setting a password to your notebook server is good practice. To add a password to you're notebook first encryt it by running this on your local interpreter:

```
from IPython import lib

lib.passwd("YOUR_PASSWORD_HERE")
```
This will return a string like `sha1:e080efd3a948:27e429c741f4e9bd0a2f83500f24b1f2dcabdb86`

Now create a `.env` to sit next to your `docker-compose.yml` file with these contents:

```
NOTEBOOK_PASSWORD=sha1:...........
```

Be sure to replace `sha1:...........` with your encrypted password.

# Deploying with Docker Compose

To deploy this image using Docker Compose create a `docker-compose.yml` file with this:

```
version: '3'
services:
  jupyterlab:
    build: https://github.com/hughcameron/jupyterlab.git
    volumes:
      - '~:/workspace'
    ports:
      - '8080:8080'
    container_name: jupyterlab
```

Then run this command from the directory holding the file:

`docker-compose up -d --build`