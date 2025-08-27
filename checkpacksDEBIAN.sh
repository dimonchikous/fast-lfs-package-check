#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}Script made by dimonchikous ${NC}"
echo "Updating system"
sudo apt update

REPORT="packages_report"

echo "" > $REPORT

PACKAGES=(
    build-essential bash binutils bison bzip2 coreutils diffutils file
    findutils gawk gcc libc6-dev gettext git grep gzip m4 make libncurses-dev
    patch perl python sed tar texinfo util-linux xz-utils libssl-dev
    which gperf help2man flex xorriso dosfstools mtools curl
    wget ca-certificates unzip zip p7zip cpio bc ed lzip python3
)

MISSING_PACKAGES=()

for package in "${PACKAGES[@]}"; do
    if dpkg -l | grep "$package"; then
	    version=$(dpkg -l | grep "$package"|awk 'print $3')
	    echo "$package $version: DOWNLOADED" >> "$REPORT"
    else
	    version=$(dpkg -l | grep "$package"|awk 'print $3')
	    echo "$package $version: MISSING" >> "$REPORT"
	    MISSING_PACKAGES+=("$package")
	   
    fi
done

if [ ${#MISSING_PACKAGES[@]} -ne 0 ]; then
    echo -e "${RED}Missing${NC}: ${MISSING_PACKAGES[*]}"
    read -p "Download this packages? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo apt-get install "${MISSING_PACKAGES[@]}"
    else
        echo "Downloading cancelled"
    fi
else
    echo -e "${GREEN}All packages is downloaded${NC}"
fi
echo -e "${RED}	Attention!"
echo -e "Verify versions of your packages!${NC}"
echo "---------------" >> "$REPORT"
