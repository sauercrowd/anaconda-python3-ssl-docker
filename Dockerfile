FROM ubuntu:16.04
RUN apt-get update && apt-get install -y python3 nginx bzip2 openssl sudo
RUN echo "conda	ALL=(ALL) 	NOPASSWD:ALL" >> /etc/sudoers
RUN mkdir /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -subj "/C=DE/ST=NRW/L=Dus/O=OrgName/OU=IT Department/CN=example.com" -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt
COPY conf /etc/nginx/conf.d/default.conf

RUN useradd -m -G users conda
ADD 'https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh' /anaconda.sh
RUN chown conda:users /anaconda.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh
USER conda
RUN /bin/bash /anaconda.sh -b
RUN echo "PATH=$PATH:/home/conda/anaconda3/bin" >> /home/conda/.bashrc
EXPOSE 443
CMD ["/home/conda/anaconda3/bin/jupyter","notebook"]
