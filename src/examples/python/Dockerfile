#
# This Dockerfile includes all dependencies needed to run the Python example
# code. As the user, you must mount the root of the `fedramp-automation`
# repository at /code (eg, via docker-compose.yml).
#

FROM ubuntu:focal as saxonica-build

# Download and build the Saxon-HE c-library
# See here for platform-specific packages: https://www.saxonica.com/download/c.xml
RUN apt-get update \
  && apt-get install -y wget unzip python3 python3-pip python3-distutils \
  && rm -rf /var/lib/apt/lists/*

# Download, build, and configure the Saxon-HE c-library
# See here for platform-specific packages: https://www.saxonica.com/download/c.xml
RUN wget -O /tmp/saxon.zip https://www.saxonica.com/download/libsaxon-HEC-setup64-v11.3.zip \
  && unzip /tmp/saxon.zip -d /opt/saxonica/ \
  && ln -s /opt/saxonica/libsaxon-HEC-11.3/libsaxonhec.so /usr/lib/libsaxonhec.so \
  && ln -s /opt/saxonica/libsaxon-HEC-11.3/rt /usr/lib/rt
ENV SAXONC_HOME=/usr/lib
ENV LD_LIBRARY_PATH=/usr/lib/rt/lib/amd64:$LD_LIBRARY_PATH

# Build the saxon-c Python extension and put on PYTHONPATH
RUN cd /opt/saxonica/libsaxon-HEC-11.3/Saxon.C.API/python-saxon \
  && pip install cython \
  && python3 saxon-setup.py build_ext -if
ENV PYTHONPATH=/opt/saxonica/libsaxon-HEC-11.3/Saxon.C.API/python-saxon

# Install Python dependencies
ADD requirements.txt /tmp
RUN pip install -r /tmp/requirements.txt
