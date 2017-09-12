# anaconda-python3-ssl-docker
An anaconda jupyer container with a bash kernel, secured with ssl 

This Dockerfile builds an image which contains a full conda installation, a jupyter kernel for bash to be able to install python modules like tensorflow easily later on, and ssl support.

ssl certificates get build on container startup, not when the image gets created.
This way every user gets a different certificate, even when pulling from the dockerhub (image jonadev95/anaconda-python3-ssl-docker)
