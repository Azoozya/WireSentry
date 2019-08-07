FROM alpine:latest
WORKDIR /root/
RUN apk update && apk add bash && apk add tshark
RUN mkdir ip_src ip_dst /archive
RUN touch ip_src/$(hostname -i)
RUN touch ip_dst/$(ifconfig | grep Bcast | cut -c 39-52)
ADD scripts/ /root/
#ENTRYPOINT ./sentry.sh $(ls ip_src) $(ls ip_dst/)
ENTRYPOINT bash
