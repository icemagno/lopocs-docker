FROM kartoza/postgis
MAINTAINER magno.mabreu@gmail.com

RUN mkdir /home/lopocs && mkdir /home/lopocs/install
ENV PROJ_LIB="/usr/local/share/proj/"
ENV FLASK_APP=lopocs


# LIBS 
RUN apt-get update && apt-get install -y --no-install-recommends build-essential \
	make \
	cmake \
	g++ \
	gcc \
	libboost-dev \
	libboost-system-dev \
	libboost-filesystem-dev \
	libexpat1-dev \
	zlib1g-dev \
	libbz2-dev \
	libpq-dev \
	libproj-dev \
	protobuf-compiler \
	libcunit1 \
	libcunit1-doc \
	libcunit1-dev \
	ninja-build \
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
#RUN cd /home/lopocs/install && \
#    git clone https://github.com/OSGeo/GDAL.git && \
#	cd GDAL/gdal && \
#	./configure --with-proj=/usr/local && \
#	make && \
#	make install 
	


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



# PGMORTON : https://github.com/Oslandia/pgmorton
RUN cd /home/lopocs/install && \
    git clone https://github.com/Oslandia/pgmorton && \
	cd pgmorton && \
	mkdir build && \
	cd build && \
	cmake .. && \
	make && \
	make install



# PGPOINTCLOUD
# PGUSER=postgres PGPASSWORD=admin PGHOST=localhost make installcheck
RUN cd /home/lopocs/install && \
    git clone https://github.com/pgpointcloud/pointcloud && \
	cd pointcloud && \
	./autogen.sh && \
	./configure --with-lazperf=/usr/local/ && \
	make && \
	make install
	
	
#  PointCloud is now configured for 
# -------------- Compiler Info ------------- 
#  C compiler:           gcc -g -O2
#  SQL preprocessor:     /usr/bin/cpp -traditional-cpp -w -P
# -------------- Dependencies -------------- 
#  PostgreSQL config:    /usr/bin/pg_config
#  PostgreSQL version:   PostgreSQL 12.3 (Debian 12.3-1.pgdg100+1) (120)
#  Libxml2 config:       /usr/bin/xml2-config
#  Libxml2 version:      2.9.4
#  LazPerf status:       /usr/local//include/laz-perf
#  CUnit status:         enabled



# PDAL : https://pdal.io/development/compilation/dependencies.html
# PGUSER=postgres PGPASSWORD=admin PGHOST=localhost PGPORT=5432 ctest
RUN cd /home/lopocs/install && \
    git clone https://github.com/PDAL/PDAL.git && \
	cd PDAL && \
	mkdir build && \
	cd build && \
	cmake -G Ninja -DLazperf_DIR=/usr/local/ -DWITH_LAZPERF=ON .. && \
	ninja && \
	ninja install

WORKDIR /home/lopocs/

