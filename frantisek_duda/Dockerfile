#Stage 1 Build
FROM golang:alpine as builder
RUN apk update && apk add --no-cache  \ 
iputils-ping \ 
sudo \
net-tools \
tcpdump # version 4.99.4-3ubuntu1 \
iproute2 \
grep \
bash \
curl
ENV PATH="/usr/sbin:${PATH}"
WORKDIR /home/duda_fr/beeit_devops_podzim_2024/frantisek_duda

COPY script.sh /home/duda_fr/beeit_devops_podzim_2024/frantisek_duda/
RUN chmod +x /home/duda_fr/beeit_devops_podzim_2024/frantisek_duda/script.sh
RUN go build -o frantisek_duda


#Stage 2
FROM golang:alpine as tester
RUN apk update && apk add --no-cache bash
WORKDIR /home/duda_fr/beeit_devops_podzim_2024/frantisek_duda
COPY . /home/duda_fr/beeit_devops_podzim_2024/frantisek_duda/
RUN go test -v > test_output.txt

RUN chmod +x /home/duda_fr/beeit_devops_podzim_2024/frantisek_duda/test.sh
RUN bash /home/duda_fr/beeit_devops_podzim_2024/frantisek_duda/test.sh > /tmp/test_output.txt


#Stage 3
FROM alpine:latest as final
RUN apk update && apk add --no-cache \
  iputils \
  sudo \
  net-tools \
  tcpdump \
  iproute2 \
  grep \
  bash
WORKDIR /home/duda_fr/beeit_devops_podzim_2024/frantisek_duda
COPY --from=tester test_output.txt /tmp/test_output.txt
COPY --from=builder /home/duda_fr/beeit_devops_podzim_2024/frantisek_duda /home/duda_fr/beeit_devops_podzim_2024/frantisek_duda
ENTRYPOINT [ "/bin/bash","/home/duda_fr/beeit_devops_podzim_2024/frantisek_duda/script.sh" ]
CMD ["arg_default"]