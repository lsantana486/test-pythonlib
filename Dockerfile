FROM centos:8

ARG AWS_CLI_VERSION=2.1.24
ARG AWS_SAM_CLI_VERSION=1.9.0
ARG AWS_CFN_GUARD_VERSION=1.0.0

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

# Java
RUN aws s3 cp s3://ps-devops/bin/jdk/8u172/jdk-8u172-linux-x64.rpm /opt/rpm/jdk-8u172-linux-x64.rpm \
    && rpm --install /opt/rpm/jdk-8u172-linux-x64.rpm && rm -rf /opt/rpm/jdk*

# Maven
RUN aws s3 cp s3://ps-devops/bin/apache-maven/3.5.3/apache-maven-3.5.3-bin.tar.gz /opt/maven/maven-3.5.3.tar.gz \
    && tar -xvzf /opt/maven/maven-3.5.3.tar.gz -C /opt/maven/ &&  rm /opt/maven/maven-3.5.3.tar.gz
COPY settings.xml /home/centos/.m2/settings.xml
RUN chown centos:centos /home/centos/.m2

# Gradle
RUN aws s3 cp s3://ps-devops/bin/gradle/5.6.1/gradle-5.6.1-bin.zip /opt/gradle/gradle-5.6.1-bin.zip \
    && unzip /opt/gradle/gradle-5.6.1-bin.zip -d /opt/gradle/ \
    && rm /opt/gradle/gradle-5.6.1-bin.zip

# CFN Guard
RUN yum install wget -y && \
    wget https://github.com/aws-cloudformation/cloudformation-guard/releases/download/${AWS_CFN_GUARD_VERSION}/cfn-guard-linux-${AWS_CFN_GUARD_VERSION}.tar.gz && \
    tar -xvf cfn-guard-linux-${AWS_CFN_GUARD_VERSION}.tar.gz && \
    chmod +x ./cfn-guard-linux/cfn-guard && \
    mv ./cfn-guard-linux/cfn-guard /usr/local/bin/

ENV JAVA_HOME=/usr/java/latest GRADLE_HOME=/opt/gradle/gradle-5.6.1 M3_HOME=/opt/maven/apache-maven-3.5.3 PATH=$PATH:/opt/maven/apache-maven-3.5.3/bin:/opt/gradle/gradle-5.6.1/bin

USER 1001
LABEL "maintainer"="HBO Engineering"

CMD [ "aws", "--version" ]
