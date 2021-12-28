Container images available at: https://hub.docker.com/repository/docker/hinchliff/rpi2-unifi-controller

## Run
```shell
docker run -d --restart always \
 -v /etc/localtime:/etc/localtime:ro \
 --name unifi \
 --volume /home/pi/unifi/config:/config \
 -p 3478:3478/udp \
 -p 8080:8080 \
 -p 8443:8443 \
 -p 8843:8843 \
 -p 8880:8880 \
 -p 6789:6789 \
 -p 10001:10001/udp \
 hinchliff/rpi2-unifi-controller:latest
```

## References
* https://github.com/jessfraz/dockerfiles/tree/master/unifi

