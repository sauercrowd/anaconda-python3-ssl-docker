#!/bin/sh

# Generate ssl certs if not exist
if [[ ! -f /home/conda/ssl/jupyter.key ]]
then
	openssl req -x509 -nodes -days 365 -subj "/C=DE/ST=Sauercrowd/L=Sauercrowd/O=Sauercrowd/OU=IT Department/CN=example.com" -newkey rsa:2048 -keyout /home/conda/ssl/jupyter.key -out /home/conda/ssl/jupyter.crt
fi

# Generate a token file if it doesn't exist
if [[ ! -f /home/jotten/.jupyter/jupyter_notebook_config.py ]]
then
	TOKEN=`pwgen 20 1`
	echo "c.NotebookApp.token = \'$TOKEN\'" > /home/conda/.jupyter/jupyter_notebook_config.py
fi


/home/conda/anaconda3/bin/jupyter notebook --certfile=/home/conda/ssl/jupyter.crt --keyfile=/home/conda/ssl/jupyter.key --ip=0.0.0.0 --no-browser
