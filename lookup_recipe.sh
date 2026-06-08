#!/bin/bash
# Part of the 'yocto_tools' GitHub repo
# 'A small, simple and useful tool collection for Yocto'
#  https://github.com/kaiwan/yocto_tools
#
# This tool is essentially a wrapper over the 'oe-pkgdata-util lookup-recipe' ;
# it's VERY time-consuming as it iterates over each IMAGE built and within it,
# each package, invoking - oe-pkgdata-util lookup-recipe <pkg> - on each package!
#
# (c) Kaiwan NB, kaiwanTECH
# License: MIT
export name=$(basename "$0")
PFX=$(dirname "$(which "$0")")    # dir in which the common code and tools reside
source "${PFX}"/common || {
  echo "${name}: could not source 'common' script, aborting..." ; exit 1
}

display_recipe_dtl()
{
PKG_MANIFEST=${1}/package.manifest
[ ! -f ${PKG_MANIFEST} ] && {
  echo "Oops, the package manifest file \"${PKG_MANIFEST}\" isn't found"
  return
}
numpkg=$(wc -l ${PKG_MANIFEST} |cut -d" " -f1)
[ ${numpkg} -le 0 ] && die "Oops, you have 0 packages generated"

echo "Looking up recipes for the ${numpkg} packages currently generated:
package-name            : recipe-to-generate-it
"
for pkg in $(cat ${PKG_MANIFEST})
do
  recp=$(oe-pkgdata-util lookup-recipe ${pkg} || true)
  printf "%-40s: %s\n" ${pkg} ${recp}
done
}


#--- 'main'
setup_env #-q

echo
for IMAGE_DIR in $(ls -d ${BUILDDIR}/tmp/deploy/licenses/${MACHINE}/*.rootfs)
do
 echo "
----------- IMAGE_DIR = ${IMAGE_DIR} -----------"
 display_recipe_dtl ${IMAGE_DIR}
done
exit 0
