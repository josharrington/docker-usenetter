This docker image automatically downloads torrents from RSS feeds and reuploads them to usenet. 

<h3>Usage</h3>

Make sure you have a host with docker installed and configured. While the scripts can be used by manually installing the necessary tools on a host, using docker makes the process much smoother. If you have never used docker before, please visit docker's <a href="https://www.docker.io/gettingstarted/">Getting Started</a> page.

Run the following:
```bash
git clone https://github.com/papersackpuppet/docker-usenetter.git
cd docker-usenetter
```

To configure the container, you need to pass environment variables to the container. You can do this by modifying the Dockerfile and replacing each ENTERME with the appropriate values for your needs. The recommended way to do this is set up defaults in the Dockerfile (such as usenet server, username, password), build the image, and pass variables as needed for each new container(such as RSS feeds, usenet groups). You can have multiple RSS feeds per container but each torrent downloaded will be uploaded to only the groups passed in. 

Expected environment variables:
```bash
RSS_FEEDS
RSS_REFRESH_TIME (in minutes, default 3)
USENET_SERVER
USENET_PORT
USENET_TLS (default on)
USENET_USERNAME
USENET_PASSWORD
USENET_POST_GROUP
USENET_POST_AS
```

Edit the Dockerfile to set default environment variables. Afterwards, run the following command.
```bash
docker build -t papersackpuppet/usenetter .
```

Next, you will need to create an environment variable file to pass to the new docker container. The contents of the file will be like below. Remove any lines that you configured in the Dockerbuild file. Options here will override options created in the Dockerbuild file.

```bash
nano envVars
```

```bash
RSS_FEEDS=http://linuxtracker.org/rss_torrents.php?feed=dl&cat[]=563&pid=00000000000000000000000000000000
RSS_REFRESH_TIME=3
USENET_SERVER=news.usenet.com
USENET_PORT=443
USENET_TLS=on
USENET_USERNAME=myusername
USENET_PASSWORD=mypassword
USENET_POST_GROUP=alt.binaries.cd.image.linux
USENET_POST_AS=LinuxUploader

```

The above example will follow the Ubuntu release RSS feed on Linuxtracker, download the images, and upload them to alt.binaries.cd.image.linux as LinuxUploader.

Run a new container:
```bash
docker run -dti --env-file 
```
