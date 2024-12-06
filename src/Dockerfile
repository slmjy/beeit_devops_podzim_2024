# First stage: build & test
FROM ubuntu:20.04 AS test

# Install necessary packages for script preparation
RUN apt-get update && apt-get install -y \
    sudo \
    docker.io \
    net-tools \
    iputils-ping \
    # dnsutils # should be installed for command dig used in custom_linux_cli 
    # but takes much time and is not that important -> excluded
    iproute2 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the script into the image
COPY ./custom_linux_cli.sh /app/

# Set executable permissions
RUN chmod +x ./custom_linux_cli.sh

# Run basic test and redirect the result to txt
RUN ./custom_linux_cli.sh -makeDir -p "/test" && \
    echo "Script executed successfully" > test_output.txt || \
    echo "Script not successful" > test_output.txt

#
# Final Stage
#

FROM ubuntu:20.04

# Install only necessary packages for running
RUN apt-get update && apt-get install -y \
    net-tools \
    iputils-ping \
    # dnsutils \
    iproute2 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the script from the build stage
COPY --from=test /app/custom_linux_cli.sh /app/
COPY --from=test /app/test_output.txt /app/

# Set executable permissions
RUN chmod +x ./custom_linux_cli.sh

# Set the ENTRYPOINT to run the script on container start
ENTRYPOINT ["./custom_linux_cli.sh"]

# Default argument
CMD ["-getIP"]



# Original file before multi-stage

# FROM ubuntu:20.04

# WORKDIR /app

# RUN apt-get update && apt-get install -y \
#     sudo \
#     docker.io \
#     net-tools \
#     iputils-ping \
#     iproute2 && \
#     rm -rf /var/lib/apt/lists/*

# # Copy the script to our image
# COPY ./custom_linux_cli.sh /app/

# # set permissions to executable
# RUN chmod +x ./custom_linux_cli.sh

# # Run a basic test
# RUN ./custom_linux_cli.sh -makeDir -p "/test" && \
#     echo "Script executed successfully"

# # Set the script to run when the container starts
# ENTRYPOINT ["./custom_linux_cli.sh"]

# # Default argument
# CMD ["-getIP"]
