#!/bin/bash
# A sample convenience script, a simple wrapper...
# We ASSUME ::
# - the machine is a Raspberry Pi variant
# - the target image is core-image-base
# - wic is being used to generate the final image files; hence, this
#   assumes you have a wic kickstart file present (it's name is in the
#   var SDIMG (without the .wks extension)).
# - you've git cloned our yocto_tools repo (for the 'burn4rpi_sd.sh script)
#-------------
# Please ENSURE you first update the SDIMG and IMG_BASE variables
#-------------

SDIMG=wic_sdimg_rpi0w
IMG_BASE=core-image-base

rm_old()
{
	local n=$(ls -1t ${SDIMG}-2023*.direct* |wc -l)
	[[ $n -le 3 ]] && return
	local numrm=$((n-3))
	echo ">>> will now rm -f these older images: ([Enter] to continue, ^C to abort)"
	ls -1t ${SDIMG}-2023*.direct* |tail -n${numrm}
	read
	rm -f $(ls -1t ${SDIMG}-2023*.direct* |tail -n${numrm})
	return 0
}

#--- 'main'
echo ">>>>>>>>> time bitbake ${IMG_BASE} || exit 1 <<<<<<<<<<<"
time bitbake ${IMG_BASE} || exit 1
echo ">>>>>>>>> wic create ./${SDIMG}.wks -e ${IMG_BASE} || exit 1 <<<<<<<<<<<"
wic create ./${SDIMG}.wks -e ${IMG_BASE} || exit 1
rm_old || exit 1
echo 'uSDcard ready?'
read
echo ">>>>>>>>> ~/yocto_tools/burn4rpi_sd.sh ${SDIMG}-*-mmcblk0.direct <<<<<<<<<<<"
~/yocto_tools/burn4rpi_sd.sh ${SDIMG}-*-mmcblk0.direct
