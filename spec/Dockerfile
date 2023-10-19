FROM ruby:3.2.2-slim-bullseye
LABEL maintainer="Rick Bradley <rick@rickbradley.com>"
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /root

# Install packages
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    rsync \
    openssh-server \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Generate SSH key and copy to authorized keys
RUN ssh-keygen -q -f /root/.ssh/id_rsa -N ""
RUN cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

COPY <<EOF /root/.ssh/config
LogLevel ERROR
Host *
    StrictHostKeyChecking accept-new
    UserKnownHostsFile=/dev/null
EOF

# Set up SSH server
RUN mkdir -p /run/sshd
RUN echo 'root:test123' | chpasswd

COPY "Gemfile" "/app/branch-deploy/"
COPY "Gemfile.lock" "/app/branch-deploy/"
COPY "script/bootstrap" "/app/branch-deploy/script/"

WORKDIR /app/branch-deploy
RUN script/bootstrap

COPY "./" "/app/branch-deploy/"

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D", "-o", "ListenAddress=0.0.0.0", "-o", "PermitRootLogin=yes", "-o", "PasswordAuthentication=yes"]
