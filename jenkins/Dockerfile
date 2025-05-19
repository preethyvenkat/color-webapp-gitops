#jenkins-dind-aws - docker in docker and aws cli

FROM jenkins/jenkins:lts

USER root

# Install required dependencies
RUN apt-get update && \
    apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release \
        unzip \
        python3 \
        python3-pip \
        software-properties-common

# Install Docker CLI and Docker Engine (for Docker-in-Docker support)
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/debian \
        $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io

# Allow Jenkins user to access Docker
RUN usermod -aG docker jenkins

# Install AWS CLI v2 (architecture-agnostic)
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Clean up
RUN apt-get clean

# Add environment PATH for Jenkins to access AWS CLI
ENV PATH="/usr/local/bin:$PATH"

USER jenkins
