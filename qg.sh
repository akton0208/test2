#!/bin/bash

MACHINE=$(hostname)
# Default parameters
DEFAULT_ACCESS_TOKEN="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjE3ZjRmNGQ4LTFhNDgtNDkyOC04YjI3LWI4NDdhMTZmMmUwYSIsIk1pbmluZyI6IiIsIm5iZiI6MTczNTYxODM1NiwiZXhwIjoxNzY3MTU0MzU2LCJpYXQiOjE3MzU2MTgzNTYsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.AbJP5Hvh2rdnWLxqdGwydkB0GlpyugPkfQSphsscpWX3cAbfmUHhCnXfFLPpahL8voj6PTVjkJJqGr6_DYR5r1uFG8qtc1Dca40ptVjHJne994zwoOzREX0z6-zgN7lXMG934ir98ijw_e7jsIJ4wDLxD2NPNfxlS6QmyiftBuwQ6RFlHT8UN-15CM1amQStHcjBXwPZfmgKI0CNMfSGNiq2bDG3_qyUur7GU8MQ-w03wqeywdVUlIIameNiqkGydLkaMTCaygL9bdxWAXoGLIMBO9XM-ol19ZREfEztj9LU8gnAfGnpiAR3XWaQuLTB7gPpxfLSSO__2ofDC9JFOQ"
ACCESS_TOKEN=${2:-$DEFAULT_ACCESS_TOKEN}

# Download and set up oula-aleominer
git clone https://github.com/gpool-cloud/gpool-cli.git
chmod -R +x gpool-cli

# Download the file
wget -O qli-Client-2.2.1-Linux-x64.tar.gz https://dl.qubic.li/downloads/qli-Client-2.2.1-Linux-x64.tar.gz

# Extract the file
tar -xzvf qli-Client-2.2.1-Linux-x64.tar.gz

# Create and write to appsettings.json file
cat <<EOL > "appsettings.json"
{
  "Settings": {
    "baseUrl": "https://mine.qubic.li/",
    "allowHwInfoCollect": true,
    "overwrites": {
      "CUDA": "12"
    },
    "accessToken": "$ACCESS_TOKEN",
    "alias": "$MACHINE",
    "idleSettings": {
      "gpuOnly": true,
      "command": "/root/gpool-cli/gpool",
      "arguments": "--pubkey J4BEb6YfzHRjNUAcSwDe1dDhLDRp7QTi1C6nnCmwAdC8"
    }
  }
}
EOL

# Run qli-Client
./qli-Client
