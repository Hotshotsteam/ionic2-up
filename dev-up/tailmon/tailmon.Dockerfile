FROM busybox:1.24.2

MAINTAINER darren@hotshots.xyz
LABEL version="1.0"
LABEL description="Simple image to run the tailmon shell script"
LABEL github="https://github.com/Hotshotsteam/tailmon"

ENV LANG C.UTF-8

ADD ./tailmon.sh /usr/bin/tailmon
RUN chmod 755 /usr/bin/tailmon

WORKDIR /project

CMD ["/project", ".tailmon"]

ENTRYPOINT tailmon
