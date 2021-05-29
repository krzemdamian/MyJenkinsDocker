FROM jenkins4eval/jenkins
 
USER root
RUN apt-get update \
      && apt-get install -y sudo
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo \
  "deb [arch=armhf signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN sudo apt-get update
RUN sudo apt-get install docker-ce-cli -y
 
USER jenkins
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

# docker run -d -v /var/run/docker.sock:/var/run/docker.sock \
#                     -v $(which docker):/usr/bin/docker \
#                     -v jenkins:/var/jenkins_home \
#                     -p 8080:8080 -p 50000:50000 \
#                     myjenkins
