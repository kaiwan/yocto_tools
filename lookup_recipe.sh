#!/bin/bash
# Part of the 'yocto_tools' GitHub repo
# 'A small, simple and useful tool collection for Yocto'
#  https://github.com/kaiwan/yocto_tools
# (c) Kaiwan NB, kaiwanTECH
# License: MIT
export name=$(basename "$0")
PFX=$(dirname "$(which "$0")")    # dir in which the common code and tools reside
source "${PFX}"/common || {
  echo "${name}: could not source 'common' script, aborting..." ; exit 1
}
setup_env #-q

IMAGE_BASENAME=$(${PFX}/showvars2 IMAGE_BASENAME |tail -n1 |cut -d: -f2)
[[ -z "${IMAGE_BASENAME}" ]] && die "couldn't fetch value of IMAGE_BASENAME"

MACHINE=$(${PFX}/showvars2 MACHINE |grep "^MACHINE" |cut -d: -f2|tail -n1)
[[ -z "${MACHINE}" ]] && die "couldn't fetch value of MACHINE"

IMAGE_MACH_DIR=$(\ls -1t -d ${BUILDDIR}/tmp/deploy/licenses/${IMAGE_BASENAME}-${MACHINE}-* |head -n1)
[[ -z "${IMAGE_MACH_DIR}" ]] && die "couldn't fetch value of the image-mach dir"
PKG_MANIFEST=${IMAGE_MACH_DIR}/package.manifest
[ ! -f ${PKG_MANIFEST} ] && die "Oops, the package manifest file \"${PKG_MANIFEST}\" isn't found"

numpkg=$(wc -l ${PKG_MANIFEST} |cut -d" " -f1)
[ ${numpkg} -le 0 ] && die "Oops, you have 0 packages generated"

echo "Looking up recipes for the ${numpkg} packages currently generated:
pkg-name: recipe-to-generate-it
"
for pkg in $(cat ${PKG_MANIFEST})
do
  recp=$(oe-pkgdata-util lookup-recipe ${pkg})
  printf "%-40s: %s\n" ${pkg} ${recp}
done
