FROM ubuntu:20.04 AS test

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    docker.io \
    net-tools \
    iputils-ping \
    # dnsutils # should be installed for command dig used in custom_linux_cli 
    # but takes much time and is not that important -> excluded
    iproute2 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY ./src/ /app/
RUN chmod +x ./custom_linux_cli.sh

# Run basic test and redirect the result to txt
RUN ./custom_linux_cli.sh -makeDir -p "/test" && \
    echo "Script executed successfully" > test_output.txt || \
    echo "Script not successful" > test_output.txt


# Final Stage
FROM ubuntu:20.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    docker.io \
    net-tools \
    iputils-ping \
    # dnsutils \
    iproute2 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the script from the test stage
COPY --from=test /app/custom_linux_cli.sh /app/
COPY --from=test /app/test_output.txt /app/

# Set ENTRYPOINT to run the script when container starts
ENTRYPOINT ["./custom_linux_cli.sh"]

# Default argument
CMD ["-getIP"]

# # Better to create non root system user - but the docker in docker commands would not be working
# # RUN groupadd -r user && useradd -r -g user user
# # USER user
