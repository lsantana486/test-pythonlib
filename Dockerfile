FROM centos:8

ARG AWS_CLI_VERSION=2.1.24
ARG AWS_SAM_CLI_VERSION=1.9.0

#Essentials
RUN dnf -y install epel-release git python3-setuptools python3-devel gcc gcc-c++ libtool zip which make zlib-devel openssl-devel libffi-devel jq

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install

RUN curl https://www.python.org/ftp/python/3.8.1/Python-3.8.1.tar.xz --output Python-3.8.1.tar.xz \
    && tar xJf Python-3.8.1.tar.xz \
    && rm Python-3.8.1.tar.xz \
    && cd Python-3.8.1 \
    && ./configure && make && make install \
    && ln -s /usr/bin/pydoc3 /usr/bin/pydoc && ln -s /usr/bin/python3 /usr/bin/python && ln -s /usr/bin/pip3 /usr/bin/pip \
    && python3.8 -m pip install setuptools wheel twine \
    && pip3 install aws-sam-cli==${AWS_SAM_CLI_VERSION}

RUN groupadd --gid 1001 centos && useradd --uid 1001 --gid centos --shell /bin/bash --create-home centos

# Node.js
RUN yum -y module install nodejs:12

# CFN Guard
RUN yum install wget -y && \
    wget https://github.com/aws-cloudformation/cloudformation-guard/releases/download/${AWS_CFN_GUARD_VERSION}/cfn-guard-linux-${AWS_CFN_GUARD_VERSION}.tar.gz && \
    tar -xvf cfn-guard-linux-${AWS_CFN_GUARD_VERSION}.tar.gz && \
    chmod +x ./cfn-guard-linux/cfn-guard && \
    mv ./cfn-guard-linux/cfn-guard /usr/local/bin/

USER 1001

CMD [ "aws", "--version" ]
