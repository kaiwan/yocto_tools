#!/bin/bash
# A sample convenience script, a simple wrapper...
# We ASSUME ::
# - the target machine is a guest run via YP's runqemu
# - your conf/local.conf has enabled EXTRA_IMAGE_FEATURES as (at least)
#   'debug-tweaks', thus allowing an ssh into the guest target as root
#-------------
# Please ENSURE you first update the IMG_BASE variable
#-------------
IMG_BASE=core-image-base

echo ">>>>>>>>> time bitbake ${IMG_BASE} || exit 1 <<<<<<<<<<<"
time bitbake ${IMG_BASE} || exit 1

echo ">>>>>>>>> runqemu qemuarm64 &"
runqemu qemuarm64 &

rm -f ssh2q
cat > ssh2q << @EOF@
#!/bin/bash
N=20
echo "sleep \$N

  ... give some time for qemu guest to init ...

Will login as root in \$N secs...
To get a subshell as another user, do
 su - <username>
"
sleep \$N  # give time for init...
[[ $(id -u) -eq 0 ]] && ssh-keygen -f "/root/.ssh/known_hosts" -R "192.168.7.2" || \
 ssh-keygen -f "/home/\${LOGNAME}/.ssh/known_hosts" -R "192.168.7.2"
ssh root@192.168.7.2
@EOF@
chmod +x ssh2q
echo ">>>>>>>>> gnome-terminal --window -- ./ssh2q &"
gnome-terminal --window -- ./ssh2q &

exit 0
