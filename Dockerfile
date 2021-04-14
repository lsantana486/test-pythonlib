FROM python-38-centos7:latest

ARG AWS_CLI_VERSION=2.1.24
ARG AWS_SAM_CLI_VERSION=1.9.0
ARG AWS_CFN_GUARD_VERSION=1.0.0

RUN dnf -y git zip which jq

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install

RUN pip install setuptools wheel twine aws-sam-cli==${AWS_SAM_CLI_VERSION}

RUN yum -y module install nodejs:12

RUN yum install wget -y && \
    wget https://github.com/aws-cloudformation/cloudformation-guard/releases/download/${AWS_CFN_GUARD_VERSION}/cfn-guard-linux-${AWS_CFN_GUARD_VERSION}.tar.gz && \
    tar -xvf cfn-guard-linux-${AWS_CFN_GUARD_VERSION}.tar.gz && \
    chmod +x ./cfn-guard-linux/cfn-guard && \
    mv ./cfn-guard-linux/cfn-guard /usr/local/bin/

