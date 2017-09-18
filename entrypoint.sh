#!/bin/sh

# Generate ssl certs if not exist
if [[ ! -f /home/conda/ssl/jupyter.key && -z ${NO_SSL+x} ]]
then
	openssl req -x509 -nodes -days 365 -subj "/C=DE/ST=Sauercrowd/L=Sauercrowd/O=Sauercrowd/OU=IT Department/CN=example.com" -newkey rsa:2048 -keyout /home/conda/ssl/jupyter.key -out /home/conda/ssl/jupyter.crt
fi

# Generate a token file if it doesn't exist
if [ ! -f /home/conda/.jupyter/jupyter_notebook_config.py ]
then
	mkdir -p /home/conda/.jupyter
	TOKEN=`pwgen 20 1`
	echo "c.NotebookApp.token = '$TOKEN'" > /home/conda/.jupyter/jupyter_notebook_config.py
	echo ""
	echo "[JUPYTER NOTEBOOK TOKEN] $TOKEN"
	echo ""
fi

if [[ -z ${NO_SSL+x} ]]
then
	/home/conda/anaconda3/bin/jupyter notebook --certfile=/home/conda/ssl/jupyter.crt --keyfile=/home/conda/ssl/jupyter.key --ip=0.0.0.0 --no-browser
else
	/home/conda/anaconda3/bin/jupyter notebook --ip=0.0.0.0 --no-browser
fi
