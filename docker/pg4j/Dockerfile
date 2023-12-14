FROM python:3.10

RUN wget -O neotechnology.gpg.key https://debian.neo4j.com/neotechnology.gpg.key 
RUN apt-key add neotechnology.gpg.key
RUN echo 'deb https://debian.neo4j.com stable 5' | tee -a /etc/apt/sources.list.d/neo4j.list

RUN apt-get update && apt-get install -y \
    postgresql-client neo4j \
    && rm -rf /var/lib/apt/lists/*
RUN pip uninstall pg4j
RUN pip install pg4j==0.1.4 --no-cache-dir

COPY docker/pg4j/migration /migration
