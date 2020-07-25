FROM debian:buster-slim
MAINTAINER magno.mabreu@gmail.com

RUN mkdir -p /home/lopocs/install && \
	mkdir -p /lopocs/cache
	
ENV PROJ_LIB="/usr/local/share/proj/"
ENV FLASK_APP=lopocs

# LIBS 
RUN apt-get update && apt-get install -y --no-install-recommends build-essential \
  make \
  cmake \
  g++ \
  libboost-dev \
  libboost-system-dev \
  libboost-filesystem-dev \
  libexpat1-dev \
  zlib1g-dev \
  libbz2-dev \
  libpq-dev \
  libproj-dev \
  lua5.2 \
  liblua5.2-dev \
  wget \
  software-properties-common \
  python3-setuptools \
  python3-matplotlib \
  python3-dev \
  python3-bs4 \
  python3-gdal \
  python3-pip \
  osmium-tool \
  curl \
  gdal-bin \
  git \
  libgdal-dev \
  sqlite3

# PROJ
RUN cd /home/lopocs/install/ && \
    wget http://download.osgeo.org/proj/proj-7.1.0.tar.gz && \
    tar -xvf proj-7.1.0.tar.gz && \
	cd proj-7.1.0 && \
    ./configure && \
	make && \
	make install && \
	ln -s /usr/local/lib/libproj.so.19 /usr/lib/libproj.so.19


# PYPROJ
RUN cd /home/lopocs/install/ && \
    git clone https://github.com/pyproj4/pyproj.git && \
	cd pyproj && \
	pip3 install -e .


# GDAL
RUN cd /home/lopocs/install && \
    git clone https://github.com/OSGeo/GDAL.git && \
	cd GDAL/gdal && \
	./configure --with-proj=/usr/local && \
	make && \
	make install 
	


# LIBGEOTIFF
RUN cd /home/lopocs/install && \
    wget https://github.com/OSGeo/libgeotiff/releases/download/1.6.0/libgeotiff-1.6.0.tar.gz && \
	tar -xvf libgeotiff-1.6.0.tar.gz && \
	cd libgeotiff-1.6.0 && \
	./configure --with-proj=/usr/local && \
	make && \
	make install 
	
	
	
# EMSDK - https://emscripten.org/docs/getting_started/downloads.html
# To tag it: ./emsdk install 1.38.45

ENV PATH="/home/lopocs/install/emsdk:${PATH}"
ENV PATH="/home/lopocs/install/emsdk/upstream/emscripten:${PATH}"
ENV PATH="/home/lopocs/install/emsdk/node/12.18.1_64bit/bin:${PATH}"
ENV EMSDK="/home/lopocs/install/emsdk"
ENV EM_CONFIG="/home/lopocs/install/emsdk/.emscripten"
ENV EM_CACHE="/home/lopocs/install/emsdk/upstream/emscripten/cache"
ENV EMSDK_NODE="/home/lopocs/install/emsdk/node/12.18.1_64bit/bin/node"

RUN cd /home/lopocs/install && \
    git clone https://github.com/emscripten-core/emsdk.git && \
	cd emsdk && \
	./emsdk install latest && \
	./emsdk activate latest && \
	. ./emsdk_env.sh
	
#	emcc -v	
#	emcc (Emscripten gcc/clang-like replacement + linker emulating GNU ld) 1.39.20
#	clang version 12.0.0 (/b/s/w/ir/cache/git/chromium.googlesource.com-external-github.com-llvm-llvm--project 55fa315b0352b63454206600d6803fafacb42d5e)
#	Target: x86_64-unknown-linux-gnu
#	Thread model: posix
#	InstalledDir: /home/lopocs/install/emsdk/upstream/bin
#	Found candidate GCC installation: /usr/lib/gcc/x86_64-linux-gnu/8
#	Selected GCC installation: /usr/lib/gcc/x86_64-linux-gnu/8
#	Candidate multilib: .;@m64
#	Selected multilib: .;@m64
#	shared:INFO: (Emscripten: Running sanity checks)	



# LAZPERF : https://github.com/hobu/laz-perf
RUN cd /home/lopocs/install && \
    git clone https://github.com/hobu/laz-perf.git  && \
	cd laz-perf && \
	mkdir build && \
	cd build && \
    cmake .. \
    -DEMSCRIPTEN=1 \
    -DCMAKE_TOOLCHAIN_FILE=/home/lopocs/install/emsdk/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake && \
    VERBOSE=1 make && \
	make install



# PDAL : https://pdal.io/development/compilation/dependencies.html
# PGUSER=postgres PGPASSWORD=admin PGHOST=localhost PGPORT=5432 ctest
RUN cd /home/lopocs/install && \
    git clone https://github.com/PDAL/PDAL.git && \
	cd PDAL && \
	mkdir build && \
	cd build && \
	cmake -DLazperf_DIR=/usr/local/ -DWITH_LAZPERF=ON .. && \
	make && \
	make install


RUN pip3 install 'Werkzeug==0.16.0' && \
    pip3 install 'numpy==1.16.0' &&  \
	pip3 install pdal && \
    pip3 install https://projects.unbit.it/downloads/uwsgi-lts.tar.gz


RUN cd /home/lopocs/install && \
    git clone https://github.com/Oslandia/lopocs && \
	mkdir /lopocs/cache 
	
# Some version adjusts	
COPY ./setup.py /home/lopocs/install/lopocs/
COPY ./lopocs.yml /home/lopocs/install/lopocs/conf
COPY ./lopocs.uwsgi.yml /home/lopocs/install/lopocs/conf
COPY ./wsgi.py /home/lopocs/install/lopocs/lopocs

RUN	cd /home/lopocs/install/lopocs/ && \
	pip3 install -e .
#   pip install .[dev]	


WORKDIR /home/lopocs/

RUN lopocs check

# root@lopocs-db:/home/lopocs# lopocs check
# [2020-07-24 03:39:43,846] DEBUG in __init__: loading config from /home/lopocs/conf/lopocs.yml
# Pdal ... 2.1.0
# Pdal plugin pgpointcloud ... ok
# PostgreSQL ... 12.3 (Debian 12.3-1.pgdg100+1)
# PostGIS extension ... 3.0.1
# PgPointcloud extension ... 1.2.1
# PgPointcloud-PostGIS extension ... 1.2.1


  






  
  
  
  



