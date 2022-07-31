FROM ubuntu:20.04 AS build

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    pkgconf \
    ca-certificates \
    software-properties-common \
    gnupg \
    gnupg2 \
    libnl-3-200 \
    libnl-route-3-200 \
    libhwloc-dev \
    libnuma1 \
    bzip2 \
    file \
    make \
    perl \
    tar \
    flex \
    git \
    curl \
    vim \
    openssh-client \
    autoconf \
    automake \
    libnuma-dev \
    build-essential \
    autoconf \
    automake \
    gfortran \
    python3-dev \
    python3-pip \
    python3-venv \
    libtool \
    wget && \
    rm -rf /var/lib/apt/lists/*


RUN export DEBIAN_FRONTEND=noninteractive && \
    wget http://developer.download.nvidia.com/compute/cuda/repos//ubuntu2004/x86_64//cuda-keyring_1.0-1_all.deb && \
    dpkg -i cuda-keyring_1.0-1_all.deb && \
    rm -rf cuda-keyring_1.0-1_all.deb

RUN apt-get update && \
    apt-get install -y --no-install-recommends  cuda-libraries-11-7 cuda-libraries-dev-11-7 cuda-minimal-build-11-7 cuda-nvtx-11-7 cuda-nvml-dev-11-7 cuda-command-line-tools-11-7 && \
    ln -s cuda-11.7 /usr/local/cuda

ENV LD_LIBRARY_PATH=/usr/local/cuda/lib:/usr/local/cuda/lib64:${LD_LIBRARY_PATH} \
    LIBRARY_PATH=/usr/local/cuda/lib64/stubs:${LIBRARY_PATH} \
    PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}

RUN ldconfig

# GNU compiler
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    g++-10 \
    gcc-10 && \
    rm -rf /var/lib/apt/lists/*
RUN update-alternatives --install /usr/bin/g++ g++ $(which g++-10) 30 && \
    update-alternatives --install /usr/bin/gcc gcc $(which gcc-10) 30 && \
    update-alternatives --install /usr/bin/gcov gcov $(which gcov-10) 30


# SLURM PMI2 version 21.08.8
RUN mkdir -p /var/tmp && wget -q -nc --no-check-certificate -P /var/tmp https://download.schedmd.com/slurm/slurm-21.08.8.tar.bz2 && \
    mkdir -p /var/tmp && tar -x -f /var/tmp/slurm-21.08.8.tar.bz2 -C /var/tmp -j && \
    cd /var/tmp/slurm-21.08.8 &&  CC=gcc CFLAGS='-mtune=native -mtune=native -O3 -pipe' CXX=g++ CXXFLAGS='-mtune=native -mtune=native -O3 -pipe' FCFLAGS='-mtune=native -mtune=native -O3 -pipe' FFLAGS='-mtune=native -mtune=native -O3 -pipe' LDFLAGS=-Wl,--as-needed ./configure --prefix=/usr/local/pmi && \
    cd /var/tmp/slurm-21.08.8 && \
    make -C contribs/pmi2 install && \
    rm -rf /var/tmp/slurm-21.08.8 /var/tmp/slurm-21.08.8.tar.bz2



# GDRCOPY version 2.3
RUN mkdir -p /var/tmp && wget -q -nc --no-check-certificate -P /var/tmp https://github.com/NVIDIA/gdrcopy/archive/v2.3.tar.gz && \
    mkdir -p /var/tmp && tar -x -f /var/tmp/v2.3.tar.gz -C /var/tmp -z && \
    cd /var/tmp/gdrcopy-2.3 && \
    mkdir -p /usr/local/gdrcopy/include /usr/local/gdrcopy/lib && \
    make CC=gcc COMMONCFLAGS='-mtune=native -mtune=native -O3 -pipe' CXX=g++ CXXFLAGS='-mtune=native -mtune=native -O3 -pipe' FCFLAGS='-mtune=native -mtune=native -O3 -pipe' FFLAGS='-mtune=native -mtune=native -O3 -pipe' LDFLAGS=-Wl,--as-needed prefix=/usr/local/gdrcopy lib lib_install && \
    echo "/usr/local/gdrcopy/lib" >> /etc/ld.so.conf.d/hpccm.conf && ldconfig && \
    rm -rf /var/tmp/gdrcopy-2.3 /var/tmp/v2.3.tar.gz
ENV CPATH=/usr/local/gdrcopy/include:$CPATH \
    LIBRARY_PATH=/usr/local/gdrcopy/lib:$LIBRARY_PATH

# KNEM version 1.1.4
RUN mkdir -p /var/tmp && cd /var/tmp && git clone --depth=1 --branch knem-1.1.4 https://gitlab.inria.fr/knem/knem.git knem && cd - && \
    mkdir -p /usr/local/knem && \
    cd /var/tmp/knem && \
    mkdir -p /usr/local/knem/include && \
    cp common/*.h /usr/local/knem/include && \
    echo "/usr/local/knem/lib" >> /etc/ld.so.conf.d/hpccm.conf && ldconfig && \
    rm -rf /var/tmp/knem
ENV CPATH=/usr/local/knem/include:$CPATH

# https://github.com/openucx/ucx.git
RUN mkdir -p /var/tmp && cd /var/tmp && git clone  https://github.com/openucx/ucx.git ucx && cd - && cd /var/tmp/ucx && git checkout v1.12.1 && cd - && \
    cd /var/tmp/ucx && \
    ./autogen.sh && \
    cd /var/tmp/ucx &&  CC=gcc CFLAGS='-mtune=native -mtune=native -O3 -pipe' CXX=g++ CXXFLAGS='-mtune=native -mtune=native -O3 -pipe' FCFLAGS='-mtune=native -mtune=native -O3 -pipe' FFLAGS='-mtune=native -mtune=native -O3 -pipe' LDFLAGS=-Wl,--as-needed ./configure --prefix=/usr/local/ucx --disable-assertions --disable-backtrace-detail --disable-debug --disable-doxygen-doc --disable-logging --disable-params-check --disable-static --enable-compiler-opt=no --enable-mt --with-cuda=/usr/local/cuda --with-gdrcopy=/usr/local/gdrcopy --with-knem=/usr/local/knem && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    rm -rf /var/tmp/ucx

# https://github.com/open-mpi/ompi.git
RUN mkdir -p /var/tmp && cd /var/tmp && git clone --depth=1 --branch v4.1.2 https://github.com/open-mpi/ompi.git ompi && cd - && \
    cd /var/tmp/ompi && \
    ./autogen.pl && \
    cd /var/tmp/ompi &&  CC=gcc CFLAGS='-mtune=native -mtune=native -O3 -pipe' CXX=g++ CXXFLAGS='-mtune=native -mtune=native -O3 -pipe' FCFLAGS='-mtune=native -mtune=native -O3 -pipe' FFLAGS='-mtune=native -mtune=native -O3 -pipe' LDFLAGS=-Wl,--as-needed ./configure --prefix=/usr/local/openmpi --disable-debug --disable-getpwuid --disable-mem-debug --disable-mem-profile --disable-memchecker --disable-oshmem --disable-static --enable-mca-no-build=btl-uct --enable-mpi-thread-multiple --enable-mpi1-compatibility --prefix=/usr/local/openmpi --with-cuda=/usr/local/cuda --with-pmi=/usr/local/pmi --with-slurm --with-ucx=/usr/local/ucx --without-verbs && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    rm -rf /var/tmp/ompi

RUN echo "/usr/local/openmpi/lib" >> /etc/ld.so.conf.d/hpccm.conf && \
    ldconfig

ENV PATH=/usr/local/openmpi/bin:${PATH}

# openfoam dependencies
RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
   build-essential autoconf autotools-dev cmake gawk gnuplot \
   flex libfl-dev libreadline-dev zlib1g-dev \
   openmpi-bin libopenmpi-dev mpi-default-bin mpi-default-dev \
   libgmp-dev libmpfr-dev libmpc-dev && \
   rm -rf /var/lib/apt/lists/*

RUN mkdir /opt/openfoam && cd /opt/openfoam && \
wget https://dl.openfoam.com/source/latest/OpenFOAM-v2206.tgz && tar -xf OpenFOAM-v2206.tgz && \
wget https://dl.openfoam.com/source/latest/ThirdParty-v2206.tgz && tar -xf ThirdParty-v2206.tgz && \
source /opt/openfoam/OpenFOAM-v2206/etc/bashrc && \
cd /opt/openfoam/OpenFOAM-v2206/ && \
./Allwmake -j -s -q -l



#RUN curl https://dl.openfoam.com/add-debian-repo.sh | bash && apt-get -y install openfoam2206-default

RUN mkdir -p /var/tmp && cd /var/tmp && \
git clone -b release https://gitlab.com/petsc/petsc.git petsc

RUN source /opt/openfoam/OpenFOAM-v2206/etc/bashrc && \
 cd /var/tmp/petsc && \
 ./configure --with-64-bit-indices=0 --download-fblaslapack --with-cuda  --with-precision=double --prefix=$WM_THIRD_PARTY_DIR/platforms/$WM_ARCH$WM_COMPILER$WM_PRECISION_OPTION$WM_LABEL_OPTION/petsc-git  PETSC_ARCH=$WM_OPTIONS && \
  make -j  all && \
  mkdir -p $WM_THIRD_PARTY_DIR/platforms/$WM_ARCH$WM_COMPILER$WM_PRECISION_OPTION$WM_LABEL_OPTION/petsc-git && \
  export PETSC_DIR=$WM_THIRD_PARTY_DIR/platforms/$WM_ARCH$WM_COMPILER$WM_PRECISION_OPTION$WM_LABEL_OPTION/petsc-git && \
  export PETSC_ARCH=$WM_OPTIONS && \
  make PETSC_DIR=/var/tmp/petsc PETSC_ARCH=linux64GccDPInt32Opt install

ENV OMPI_ALLOW_RUN_AS_ROOT=1
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1
ENV PETSC_DIR=/opt/openfoam/ThirdParty-v2206/platforms/linux64GccDPInt32/petsc-git/
ENV PETSC_ARCH=linux64GccDPInt32
ENV LD_LIBRARY_PATH=/opt/openfoam/ThirdParty-v2206/platforms/linux64GccDPInt32/petsc-git/lib:$LD_LIBRARY_PATH 

RUN source /opt/openfoam/OpenFOAM-v2206/etc/bashrc &&  mkdir -p /var/tmp && cd /var/tmp && git clone -b v2206 https://develop.openfoam.com/modules/external-solver.git petscfoam && cd /var/tmp/petscfoam  &&  ./Allwmake && foamHasLibrary -verbose petscFoam

RUN mkdir -p /home/ && cd /home/ && git clone -b petsc https://github.com/radiolok/fluidicpc.git fluidicpc