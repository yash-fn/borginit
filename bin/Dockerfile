FROM python:3.9-slim

RUN DEBIAN_FRONTEND=noninteractive apt update && apt -y install \
	libssl-dev libacl1-dev liblz4-dev libzstd-dev pkg-config \
	libfuse-dev fuse \
	build-essential \
	zlib1g-dev libbz2-dev libncurses5-dev libreadline-dev liblzma-dev libsqlite3-dev libffi-dev \
	&& rm -rf /var/lib/apt/lists/*

COPY borgsource.tgz /

RUN tar xf borgsource.tgz && mv borgbackup* borg

WORKDIR /borg

RUN pip install -U wheel pip pyinstaller && \
	pip install -r requirements.d/development.lock.txt && \
	pip install -r requirements.d/fuse.txt && \
	python setup.py clean && pip install -e .[fuse]

RUN pyinstaller --distpath=/borg -F -n borg src/borg/__main__.py

FROM ubuntu:latest

RUN apt update && apt -y install sudo fuse && rm -rf /var/lib/apt/lists/*

COPY ./docker-entrypoint.sh /entrypoint.sh 

RUN chmod +x /entrypoint.sh

COPY --from=0 /borg/borg /borg/borg

ENTRYPOINT ["/entrypoint.sh"]
