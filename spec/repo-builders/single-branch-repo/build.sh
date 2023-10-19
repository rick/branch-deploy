#!/bin/bash

set -x

ROOT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && cd .. && pwd )

echo "This is a README.md" > README.md
git add README.md
git commit -m "Initial commit"
