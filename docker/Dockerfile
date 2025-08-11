FROM stablebaselines/rl-baselines3-zoo

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

USER root

RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub


FROM python:3.10-slim-bullseye

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    gcc \
    make \
    tar \
    && rm -rf /var/lib/apt/lists/*

# Build and install TA-Lib C library
RUN wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz && \
    tar -xvzf ta-lib-0.4.0-src.tar.gz && \
    cd ta-lib && \
    ./configure --prefix=/usr && \
    make && \
    make install && \
    cd .. && rm -rf ta-lib ta-lib-0.4.0-src.tar.gz

# Make sure linker can find it
ENV LD_LIBRARY_PATH=/usr/lib
RUN apt-get update && apt-get install -y swig

# Now install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install  -r requirements.txt


RUN pip install jupyterlab

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

# copy the code instead of mounting
COPY . .

ENTRYPOINT ["/usr/bin/tini", "--"]

CMD ["jupyter", "lab", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--NotebookApp.token=''","--NotebookApp.password=''","--allow-root"]
