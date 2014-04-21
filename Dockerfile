FROM ubuntu

MAINTAINER papersackpuppet

# Install packages
RUN echo 'deb http://archive.ubuntu.com/ubuntu precise main universe multiverse' > /etc/apt/sources.list
RUN apt-get update && apt-get install -y cron rtorrent par2 rar python2.7 python-setuptools tmux
RUN easy_install feedparser

# Add files
ADD include /root
ADD include/.rtorrent.rc /root/.rtorrent.rc

# Set environment variables
ENV HOME /root

# RSS Feeds to watch, space delimited
ENV RSS_FEEDS ENTERME

# Time in minutes to refresh the rss feed
ENV RSS_REFRESH_TIME 3

# Usenet connection info. TLS can be on or off
ENV USENET_SERVER ENTERME
ENV USENET_PORT ENTERME
ENV USENET_TLS on
ENV USENET_USERNAME ENTERME
ENV USENET_PASSWORD ENTERME

# Groups to post the files to, comma delimited
ENV USENET_POST_GROUP ENTERME

# The user to post the files as
ENV USENET_POST_AS ENTERME

# Run stuff
CMD ["/root/start.sh"]
