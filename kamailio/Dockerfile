ARG KAM_VERSION=5.6.3
FROM whosgonna/kamailio-apks:$KAM_VERSION AS apks


FROM alpine

COPY --from=apks /home/builder /builder

## This will install all modules except Python2 (because it's depricated in
## the current alpine build.  List any additional Kamailio modules, etc as
## needed to be deployed into the image.

RUN --mount=type=bind,from=apks,source=/home/builder,target=/builder \
       cp builder/.abuild/-62633096.rsa.pub /etc/apk/keys/ \
    && echo '/builder/packages/kamailio/' >> /etc/apk/repositories \
    && apk add --no-cache kamailio kamailio-db kamailio-http_async kamailio-jansson \
                          kamailio-extras kamailio-debugger kamailio-json \
                          kamailio-xhttp_prom kamailio-uuid sngrep sipp \
    && mkdir -p /usr/lib64/kamailio \
    && ln -s /usr/lib/kamailio/modules/ /usr/lib64/kamailio/modules


# COPY SIP/np1/kamailio.cfg /etc/kamailio/kamailio.cfg
# COPY SIP/np1/kamailio.d   /etc/kamailio/kamailio.d

ENTRYPOINT ["kamailio", "-ddDDE", "-u", "kamailio", "-g", "kamailio"]
CMD [ "-M", "4", "-m", "16", "-n", "1" ]

LABEL maintainer="kaufman"
LABEL company="BCMOne"
LABEL com.bcmone.brand="NexVortex"
LABEL com.nexvortex.role="Core"
LABEL kamailio_version="$KAM_VERSION"
