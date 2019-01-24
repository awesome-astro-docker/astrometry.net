FROM ubuntu:18.04
RUN apt-get -y update && apt-get install -y apt-utils
#    python-pyfits \
RUN apt-get install -y --no-install-recommends \
    make \
    gcc \
    zlib1g-dev \
    libcairo2-dev \
    libnetpbm10-dev \
    netpbm \
    libpng12-dev \
    libjpeg-dev \
    python-numpy \
    python-dev \
    libbz2-dev \
    swig \
    pkg-config \
    git \
    libcfitsio-dev \
    python-pip \
    python-pil \
    python-matplotlib \
    python-tk \
    file \
    apt-utils \
    libgsl-dev \
    wget && \
    # Remove APT files
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Python related stuff
RUN pip install --upgrade\
    pip
RUN for x in \
    setuptools \
    wheel \
    fitsio \
    scipy \
    #astropy \
    ; do pip install $x; done

RUN mkdir -p /src \
    && cd /src \
    && git clone http://github.com/dstndstn/astrometry.net.git astrometry \
    && cd astrometry \
    && make \
    && make py \
    && make extra \
    && make install INSTALL_DIR=/usr/local

