#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}Script made by dimonchikous ${NC}"

REPORT="packages_report"

PACKAGES=(
    base-devel bash binutils bison bzip2 coreutils diffutils file
    findutils gawk gcc glibc gettext git grep gzip m4 make ncurses
    patch perl python sed tar texinfo util-linux xz openssl
    which gperf help2man flex libisoburn dosfstools mtools curl
    wget ca-certificates unzip zip p7zip cpio bc ed lzip
)

MISSING_PACKAGES=()

for package in "${PACKAGES[@]}"; do
    if pacman -Q "$package"; then
	    version=$(pacman -Q "$package" | awk '{print $2}')
	    echo "$package $version: DOWNLOADED" >> "$REPORT"
    else
	    version=$(pacman -Q "$package" | awk '{print $2}')
	    echo "$package $version: MISSING" >> "$REPORT"
	    MISSING_PACKAGES+=("$package")
	   
    fi
done

if [ ${#MISSING_PACKAGES[@]} -ne 0 ]; then
    echo -e "${RED}Missing${NC}: ${MISSING_PACKAGES[*]}"
    read -p "Download this packages? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo pacman -S --needed "${MISSING_PACKAGES[@]}"
    else
        echo "Downloading cancelled"
    fi
else
    echo -e "${GREEN}All packages is downloaded${NC}"
fi
echo -e "${RED}	Attention!"
echo -e "Verify versions of your packages!${NC}"
echo "---------------" >> "$REPORT"
