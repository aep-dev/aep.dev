#!/usr/bin/env bash
set -x
export AEP_LOCATION="${PWD}"
export SG_DIRECTORY="/tmp/site-generator"
export AEP_LINTER_LOC="${SG_DIRECTORY}/api-linter"
if [ ! -d "${SG_DIRECTORY}" ]; then
    git clone https://github.com/aep-dev/site-generator.git "${SG_DIRECTORY}"
fi

if [ ! -d "${AEP_LINTER_LOC}" ]; then
    git clone https://github.com/aep-dev/api-linter.git "${AEP_LINTER_LOC}"
fi
cd "${SG_DIRECTORY}" || exit
# make rules / website folder
mkdir -p src/content/docs/tooling/linter/rules
mkdir -p src/content/docs/tooling/website
npm install
npm run generate
npm run build
