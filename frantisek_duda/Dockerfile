#Stage 1 Build
FROM golang:alpine as builder
ENV PATH="/usr/sbin:${PATH}"

RUN apk update && apk add --no-cache bash
WORKDIR /home/duda_fr/beeit_devops_podzim_2024/frantisek_duda

COPY script.sh /home/duda_fr/beeit_devops_podzim_2024/frantisek_duda/
RUN chmod +x /home/duda_fr/beeit_devops_podzim_2024/frantisek_duda/script.sh




#Stage 2
FROM golang:alpine as tester
RUN apk update && apk add --no-cache bash 
WORKDIR /home/duda_fr/beeit_devops_podzim_2024/frantisek_duda
COPY --from=builder /home/duda_fr/beeit_devops_podzim_2024/frantisek_duda /home/duda_fr/beeit_devops_podzim_2024/frantisek_duda
RUN echo "Spouštím test skriptu s argumentem: -test_argument" \
    && /home/duda_fr/beeit_devops_podzim_2024/frantisek_duda/script.sh "-test_argument" > /test_output.txt \
    && echo "Výstup skriptu: $(cat /test_output.txt)" \
    && awk '/-test_argument/' /test_output.txt || (echo "Test selhal!" && exit 1)


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
COPY --from=tester /test_output.txt /tmp/test_output.txt
COPY --from=builder /home/duda_fr/beeit_devops_podzim_2024/frantisek_duda /home/duda_fr/beeit_devops_podzim_2024/frantisek_duda
ENTRYPOINT [ "/bin/bash","/home/duda_fr/beeit_devops_podzim_2024/frantisek_duda/script.sh" ]
CMD ["arg_default"]