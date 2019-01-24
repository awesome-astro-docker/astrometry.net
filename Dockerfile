FROM ubuntu:18.04
RUN apt -y update && apt install -y apt-utils
#    python-pyfits \
RUN DEBIAN_FRONTEND=noninteractive \
    apt install -y --no-install-recommends \
    make \
    gcc \
    git \
    file \
    pkg-config \
    wget \
    swig \
    netpbm \
    zlib1g-dev \
    libbz2-dev \
    libcairo2-dev \
    libcfitsio-dev \
    libgsl-dev \
    libjpeg-dev \
    libnetpbm10-dev \
    libpng-dev \
    python3-minimal \
    python3-numpy \
    python3-dev \
    python3-pip \
    python3-pil \
    python3-matplotlib \
    python3-tk \
    # Remove APT files
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Python related stuff
RUN pip3 install --upgrade\
    pip
RUN for x in \
    setuptools \
    wheel \
    fitsio \
    scipy \
    #astropy \
    ; do pip3 install $x; done

RUN mkdir -p /src \
    && export PYTHON=python3 \
    && export PYTHON_SCRIPT="/usr/bin/env python3" \
    && cd /src \
    && git clone http://github.com/dstndstn/astrometry.net.git astrometry \
    && cd astrometry \
    && make \
    && make py \
    && make extra \
    && make install INSTALL_DIR=/usr/local \
    && make clean

# Demo
RUN cd /tmp && \
   build-astrometry-index -d 3 -o index-9918.fits -P 18 -S mag -B 0.1 -s 0 -r 1 -I 9918 -M -i /usr/local/examples/tycho2-mag6.fits && \
   echo "add_path .\ninparallel\nindex index-9918.fits" > 99.cfg && \
   cat 99.cfg && \
   solve-field --config 99.cfg /usr/local/examples/apod4.jpg  --continue
