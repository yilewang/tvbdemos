
#!/usr/bin/env bash

MCR_VERSION="R2017b"
INSTALL_ZIP="MCR_${MCR_VERSION}_glnxa64_installer.zip"
# TODO: rewrite so MCR_VERSION aligns with INSTALL_DIR name
# super low priority though
INSTALL_DIR="MCR_2017b_glnxa64"

if [[ ! -f $INSTALL_ZIP ]]; then
    echo "Installation .zip not found. Downloading from Mathworks website..."
    wget "https://www.mathworks.com/supportfiles/downloads/${MCR_VERSION}/deployment_files/${MCR_VERSION}/installers/glnxa64/MCR_${MCR_VERSION}_glnxa64_installer.zip"
    echo "Done."
else
    echo "Existing installation .zip found. Using that."
fi


mkdir $INSTALL_DIR

unzip $INSTALL_ZIP -d $INSTALL_DIR

cd $INSTALL_DIR

export DIR=`pwd`

echo $DIR

./install -mode silent -agreeToLicense yes -destinationFolder $DIR

