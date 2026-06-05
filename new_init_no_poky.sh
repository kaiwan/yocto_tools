#!/bin/bash
# Correct way to setup the Yocto >=5.3 (Whinlatter) layers directory layout

# Turn on unofficial Bash 'strict mode'! V useful
# "Convert many kinds of hidden, intermittent, or subtle bugs into immediate, glaringly obvious errors"
# ref: http://redsymbol.net/articles/unofficial-bash-strict-mode/ 
set -euo pipefail

name=$(basename $0)
die()
{
echo >&2 "FATAL: $*" ; exit 1
}
warn()
{
echo >&2 "WARNING: $*"
}

# runcmd
# Parameters
#   $1 ... : params are the command to run
runcmd()
{
	[[ $# -eq 0 ]] && return
	echo "$@"
	eval "$@"
}

usage()
{
	echo "Usage: ${name} [yocto-ver-to-git-clone; eg. 5.0]
F.e. ${name} 5.0  will bring in the yocto-5.0 'Scarthgap' release
DEFAULTS to yocto 6.0 (Wrynose)"
}


#--- 'main' ---
set +u
[[ "$1" = "-h" || "$1" = "-?" || "$1" = "--help" ]] && {
  usage ; exit 0
}
set -u

YOCTO_VER=6.0
[[ $# -eq 1 ]] && YOCTO_VER=${1}

UPSTREAM_LAYERS_DIR=upstream_layers
[[ ! -d ${UPSTREAM_LAYERS_DIR} ]] && mkdir ${UPSTREAM_LAYERS_DIR}
MYPRJ_LAYERS=myprj_layers

echo "NOTE!!!
You are currently in this dir: 

$(pwd)

The Yocto ver ${YOCTO_VER} git clone will be done here:
$(pwd)/${UPSTREAM_LAYERS_DIR}
and the 'project' dir here:
$(pwd)/${UPSTREAM_LAYERS_DIR}

Confirm pl: [Enter] to continue, ^C to abort...
"
read

runcmd "git clone -b yocto-${YOCTO_VER} https://git.openembedded.org/bitbake ./${UPSTREAM_LAYERS_DIR}/bitbake" || true
runcmd "git clone -b yocto-${YOCTO_VER} https://git.openembedded.org/openembedded-core ./${UPSTREAM_LAYERS_DIR}/openembedded-core" || true
runcmd "git clone -b yocto-${YOCTO_VER} https://git.yoctoproject.org/meta-yocto ./${UPSTREAM_LAYERS_DIR}/meta-yocto" || true
runcmd "git clone -b yocto-${YOCTO_VER} https://git.yoctoproject.org/yocto-docs ./${UPSTREAM_LAYERS_DIR}/yocto-docs" || true
runcmd "mkdir -p ${MYPRJ_LAYERS}" || true

echo "Done; now get started like this:

1. EVERY time, source the env script:
source ${UPSTREAM_LAYERS_DIR}/openembedded-core/oe-init-build-env [build_dirname]

2. Create and maintain your own layers in another dir (which is version
controlled, f.e. via git). We've created the ${MYPRJ_LAYERS} for this purpose.


"
exit 0
