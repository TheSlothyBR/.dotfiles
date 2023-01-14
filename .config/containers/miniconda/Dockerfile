#
#   ref https://github.com/tebeka/pythonwise/blob/master/docker-miniconda/Dockerfile
#
#   miniconda vers: http://repo.continuum.io/miniconda
#   sample variations:
#     Miniconda3-latest-Linux-armv7l.sh
#     Miniconda3-latest-Linux-x86_64.sh
#     Miniconda3-py38_4.10.3-Linux-x86_64.sh
#     Miniconda3-py37_4.10.3-Linux-x86_64.sh
#
#   py vers: https://anaconda.org/anaconda/python/files
#   tf vers: https://anaconda.org/anaconda/tensorflow/files
#   tf-mkl vers: https://anaconda.org/anaconda/tensorflow-mkl/files
#
#   ARG can be ovewriten in build by –-build-arg flag
#   reference for --mount:https://docs.docker.com/engine/reference/builder/
#

ARG DISTRO=alpine
ARG IMAGE_VER=edge
ARG CONDA_VER=latest
ARG OS_TYPE=x86_64
ARG PY_VER=3.9.9
#ARG COMMAND="apk add"
# Installs Tensorflow
#ARG TF_VER=2.5.0 
#ARG PACKAGES="git nvim"

FROM ${DISTRO}:${IMAGE_VER}

# System packages 
#RUN ${COMMAND} ${PACKAGES}

# Use the above args during building https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG CONDA_VER
ARG OS_TYPE
# Install miniconda to /miniconda
RUN curl -LO "http://repo.continuum.io/miniconda/Miniconda3-${CONDA_VER}-Linux-${OS_TYPE}.sh"
RUN bash Miniconda3-${CONDA_VER}-Linux-${OS_TYPE}.sh -p /miniconda -b
RUN rm Miniconda3-${CONDA_VER}-Linux-${OS_TYPE}.sh
ENV PATH=/miniconda/bin:${PATH}
RUN conda update -y conda

ARG PY_VER
#ARG TF_VER
# Install packages from conda (-C anaconda) and downgrade py (optional).
RUN conda install -y python=${PY_VER}
#RUN conda install -c anaconda -y \
#    tensorflow-mkl=${TF_VER} \
#    && pip install pyyaml pandas

# some devs like to let it hang https://stackoverflow.com/a/42873832/868736
# ENTRYPOINT ["tail", "-f", "/dev/null"]