#!/bin/bash

### Function definition ###

display_help() {
    echo "Invalid parameter. Example usage:"
    echo "$0 -makeDir -p \"./newdir\""
    echo "$0 -makeFile -p \"file.txt\""
    echo "$0 -addContent -p \"file.txt\" -c \"Blabla\""
    echo "$0 -createLink -p \"/path/to/existingfile.txt\" -l \"/path/to/linkname.txt\""
    echo "$0 -getIP"
    echo "$0 -interfaces"
    echo "$0 -ping -t \"google.com\""
    echo "$0 -getHostIP -h \"seznam.cz\""
    echo "$0 -listDockerImages"
    echo "$0 -listDockerContainers"
    echo "$0 -findDockerImage -n \"image_name\""
    echo "$0 -findDockerContainer -n \"container_name\""
    echo "$0 -killProcess -i 1234 -m SIGTERM"
    exit 1
}

make_dir() {
    if [ -d "$INPUT_PATH" ]; then
        echo "Directory already exists at $INPUT_PATH"
    else
        mkdir -p "$INPUT_PATH"
        if [ $? -eq 0 ]; then
            echo "Prepared a new directory called $INPUT_PATH"
        fi
    fi
}

make_file() {
    if [ -e "$INPUT_PATH" ]; then
        echo "File already exists at $INPUT_PATH"
    else
        touch "$INPUT_PATH"
        echo "Prepared a new file called $INPUT_PATH"
    fi
}

check_and_grant_write_permission() {
    if [ ! -w "$INPUT_PATH" ]; then
        echo "You do not have write permission to the file $INPUT_PATH."
        echo "Would you like to allow write access? (y/n)"
        read permission_decision
        if [[ "$permission_decision" == "y" ]]; then
            sudo chmod u+w "$INPUT_PATH"
            if [ $? -eq 0 ]; then
                echo "Write permission granted for $INPUT_PATH."
            else
                echo "Failed to change permissions for $INPUT_PATH. Exiting."
                exit 1
            fi
        else
            echo "No action performed - write permission required."
            exit 1
        fi
    fi
}

add_content_to_file() {
    if [ -e "$INPUT_PATH" ]; then
        check_and_grant_write_permission
        echo "File already exists at $INPUT_PATH"
        echo "Would you like to overwrite (o), append the content (a) or just skip (other button)?"
        read decision
        if [[ "$decision" == "o" ]]; then
            echo "$CONTENT" > "$INPUT_PATH"
            echo "File content overwritten with new content."
        elif [[ "$decision" == "a" ]]; then
            echo "$CONTENT" >> "$INPUT_PATH"
            echo "File successfully appended."
        else
            echo "No action performed."
        fi
    else
        echo "$CONTENT" > "$INPUT_PATH"
        echo "File created with your desired content."
    fi
}

create_link_to_file() {
    # Check if the input file exists and if the link path is valid (not a directory or already exists)
    if [ ! -e "$INPUT_PATH" ]; then
        echo "Error: The file $INPUT_PATH does not exist -> unable to create a link."
        exit 1
    fi
    check_and_grant_write_permission
    echo "Would you like to create a symbolic link (s) or hard link (h)?"
    read link_response
    if [ "$link_response" == "s" ]; then
        ln -s "$INPUT_PATH" "$LINKPATH"
        if [ $? -eq 0 ]; then
            echo "Symbolic link pointing at $INPUT_PATH created"
        fi
    elif [ "$link_response" == "h" ]; then
        ln "$INPUT_PATH" "$LINKPATH"
        if [ $? -eq 0 ]; then
            echo "Copy of $INPUT_PATH created"
        fi
    else
        echo "Option not supported, choose either s/h"
        exit 1
    fi
}

get_your_ip_mac_address() {
    echo "Basic Network Information:"
    IP_ADDR=$(hostname -I)
    MAC_ADDR=$(ip link | grep 'link/ether' | awk '{print $2}') # print part after link/ether
    echo "Your IP Address: $IP_ADDR"
    echo "Your MAC Address: $MAC_ADDR"
}

get_interfaces() {
    echo "Network Interfaces:"
    ip -o link show | awk '{print "Interface:", $2, "Status:", $9, "MAC Address:", $17}'
}

ping_target() {
    if [ -z "$TARGET" ]; then
        echo "Error: No target specified for ping."
        exit 1
    fi
    echo "How many requests would you like to send?"
    read PING_COUNT
    if ! [[ "$PING_COUNT" =~ ^[0-9]+$ ]]; then
        echo "Error: PING_COUNT must be a valid number."
        exit 1
    fi
    echo "Pinging $TARGET with $PING_COUNT requests..."
    ping -c "$PING_COUNT" "$TARGET"
}

get_ip_from_host() {
    if [ -z "$HOSTNAME" ]; then
        echo "Error: No hostname specified."
        exit 1
    fi
    echo "Getting IP addresses for $HOSTNAME..."
    dig +short "$HOSTNAME"
}

list_docker_images() {
    echo "Listing all Docker images:"
    sudo docker images || { echo "Error: Docker is not running."; exit 1; }
}

list_docker_containers() {
    echo "Listing all Docker containers:"
    sudo docker ps -a || { echo "Error: Docker is not running."; exit 1; }
}

find_docker_image() {
    echo "Searching for Docker image: $IMAGE_NAME"
    if sudo docker images | grep -q "$IMAGE_NAME"; then
        echo "Docker image '$IMAGE_NAME' exists."
    else
        echo "Docker image '$IMAGE_NAME' does not exist."
        exit 1
    fi
}

find_docker_container() {
    echo "Searching for Docker container: $CONTAINER_NAME"
    if sudo docker ps -a | grep -q "$CONTAINER_NAME"; then
        echo "Docker container '$CONTAINER_NAME' exists."
    else
        echo "Docker container '$CONTAINER_NAME' does not exist."
        exit 1
    fi
}

kill_process() {
    if [ -z "$PID" ]; then
        echo "Error: PID must be specified with -i."
        exit 1
    fi

    if [ -z "$MODE" ]; then
        echo "Error: Signal mode must be specified with -m."
        exit 1
    fi

    if [ "$PID" -eq 1 ]; then
        echo "Error: Cannot kill process with PID 1 for safety reasons."
        exit 1
    fi

    echo "Attempting to kill process with PID $PID using signal $MODE..."
    if sudo kill "-$MODE" "$PID"; then
        echo "Process $PID successfully killed with signal $MODE."
    else
        echo "Failed to kill process $PID."
        exit 1
    fi
}

### Part controlling the first input param ###
### providing help if args are not supported ###

ACTION=""
case "$1" in
    -makeDir) ACTION="makeDir" ;;
    -makeFile) ACTION="makeFile" ;;
    -addContent) ACTION="addContent" ;;
    -createLink) ACTION="createLink" ;;
    -getIP) ACTION="getIP" ;;
    -getHostIP) ACTION="getHostIP" ;;
    -ping) ACTION="ping" ;;
    -interfaces) ACTION="interfaces" ;;
    -listDockerImages) ACTION="listDockerImages" ;;
    -listDockerContainers) ACTION="listDockerContainers" ;;
    -findDockerImage) ACTION="findDockerImage" ;;
    -findDockerContainer) ACTION="findDockerContainer" ;;
    -killProcess) ACTION="killProcess" ;;
    *) display_help ; exit 1 ;;
esac
shift     # shifting an argument because of getopts bellow

### Main script orchestrating the specified action ###

while getopts "p:c:l:h:t:n:i:m:" OPT; do
    case "${OPT}" in
        p) INPUT_PATH=$OPTARG ;;
        c) CONTENT=$OPTARG ;;
        l) LINKPATH=$OPTARG ;;
        h) HOSTNAME=$OPTARG ;;
        t) TARGET=$OPTARG ;;
        n) NAME=$OPTARG ;;
        i) PID=$OPTARG ;;
        m) MODE=$OPTARG ;;
        *) display_help ;;
    esac
done

case "$ACTION" in
    makeDir)
        make_dir ;;
    makeFile)
        make_file ;;
    addContent)
        add_content_to_file ;;
    createLink)
        create_link_to_file ;;
    getIP)
        get_your_ip_mac_address ;;
    getHostIP)
        get_ip_from_host ;;
    ping)
        ping_target ;;
    interfaces)
        get_interfaces ;;
    listDockerImages)
        list_docker_images ;;
    listDockerContainers)
        list_docker_containers ;;
    findDockerImage)
        IMAGE_NAME=$NAME
        find_docker_image ;;
    findDockerContainer)
        CONTAINER_NAME=$NAME
        find_docker_container ;;
    killProcess)
        kill_process ;;
    *)
        display_help ;;
esac
