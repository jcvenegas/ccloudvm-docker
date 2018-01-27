FROM alpine:latest
RUN apk add --no-cache bash qemu go git musl-dev libpthread-stubs openssh-keygen openssh-client xorriso qemu-img qemu-system-x86_64

ENV GOPATH=/gopath
ENV PATH=$PATH:$GOPATH/bin
RUN go get github.com/intel/ccloudvm
RUN cp $GOPATH/bin/ccloudvm /bin/ccloudvm


ENTRYPOINT ["/bin/bash"]
