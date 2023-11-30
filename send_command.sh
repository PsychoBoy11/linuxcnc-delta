#!/bin/bash

# Constants
driveParametersAddress="0x3210"
storeParametersAddress="0x1010"
slaveRange="{0..2}"

# Check the command and the number of arguments
if [ "$1" == "write" ] && [ "$#" -ne 4 ]; then
    echo "Usage for 'write': $0 write <subindex> <value>"
    exit 1
elif [ "$1" == "save" ] && [ "$#" -ne 2 ]; then
    echo "Usage for 'save': $0 save <category>"
    exit 1
elif [ "$1" == "read" ] && [ "$#" -ne 2 ]; then
    echo "Usage for 'read': $0 read <subindex>"
    exit 1
elif [ "$#" -lt 2 ]; then
    echo "Invalid usage. Please provide a command ('write', 'read' or 'save') and the necessary parameters."
    exit 1
fi

command="$1"

case $command in
    "write")
        subindex="$2"
        value="$3"
        
        # Loop for downloading values
        for i in $slaveRange; do
            ethercat download --type int32 -p $i $driveParametersAddress $subindex $value
        done
        
        # Loop for uploading and checking values
        for i in $slaveRange; do
            result=$(ethercat upload --type int32 -p $i $driveParametersAddress $subindex)
            if [[ $result != *"$value"* ]]; then
                echo "Error: Value mismatch for slave $i. Expected $value but got $result"
            fi
        done
        ;;
    
    "read")
        subindex="$2"
        
        # Loop for uploading values and displaying the output
        for i in $slaveRange; do
            result=$(ethercat upload --type int32 -p $i $driveParametersAddress $subindex)
            echo "Slave $i: $result"
        done
        ;;
    
    "save")
        category="$2"
        
        # Loop for downloading values
        for i in $slaveRange; do
            ethercat download --type int32 -p $i $storeParametersAddress $category 0x65766173
        done
        
        # Loop for uploading and checking values
        for i in $slaveRange; do
            result=$(ethercat upload --type int32 -p $i $storeParametersAddress $category)
            if [[ $result != *"1"* ]]; then
                echo "Error: Value mismatch for index $i. Expected 1 but got $result"
            fi
        done
        ;;
    
    *)
        echo "Invalid command. Supported commands are 'write', 'read' and 'save'."
        ;;
esac
