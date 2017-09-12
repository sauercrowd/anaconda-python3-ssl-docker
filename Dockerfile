FROM ubuntu:16.04
RUN apt-get update && apt-get install -y bzip2 openssl

RUN useradd -m -G users conda
RUN mkdir /home/conda/ssl
RUN chown -R conda:users /home/conda/ssl
ADD 'https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh' /anaconda.sh
RUN chown conda:users /anaconda.sh

# jupyer kernels will crash otherwise
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]

USER conda
RUN /bin/bash /anaconda.sh -b
RUN rm /ananconda.sh

RUN echo "export PATH=$PATH:/home/conda/anaconda3/bin" >> /home/conda/.bashrc

EXPOSE 8888
WORKDIR /home/conda/
CMD ["/home/conda/anaconda3/bin/jupyter","notebook","--certfile=/home/conda/ssl/jupyter.crt","--keyfile=/home/conda/ssl/jupyter.key","--ip=0.0.0.0","--no-browser"]
