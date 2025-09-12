#  docker build -t py_assets .
FROM ubuntu:22.04

# Imposta le variabili per evitare interazioni durante l'installazione dei pacchetti
ARG DEBIAN_FRONTEND=noninteractive

# Aggiorna i pacchetti e installa le dipendenze necessarie
RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    fuse \
    python3.11 \
    python3.11-distutils \
    python3-pip \
    python3-setuptools \
    git

# Imposta Python 3.11 come versione predefinita
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1

ENV OUTPATH='/py_packge/ubuntu22.04'

RUN rm -rf /var/lib/apt/lists/*; \
    apt-get purge -y --auto-remove; \
    apt-get autoremove; \
    apt-get clean;
COPY ./startup.sh /startup.sh
CMD chmod +x /startup.sh

CMD ["/bin/sh", "/startup.sh"]
