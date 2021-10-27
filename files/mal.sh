export CURRENTUSER=$(whoami)
SCRIPTDIR=$(readlink -f "$0")
CURRENTDIR=$(dirname "$SCRIPTDIR")
SYS=$CURRENTDIR/sys
VEN=$CURRENTDIR/ven
CURRENTUSER=$2
PORTZIP=$1
OUTP=$CURRENTDIR/out
set -e

rm -rf $OUTP $SYS $VEN || true
mkdir $OUTP

#MIUI ZIP Process
printf "\n" 
printf "starting process"
printf "\n" 
printf "take 1-? minutes...."
printf "\n" 
printf "\n" 
printf "Your device is 6X"
printf "\n" 
printf "\n" 

chown $CURRENTUSER:$CURRENTUSER $OUTP
cp -Raf $CURRENTDIR/zip $OUTP/

tar --wildcards -xf $PORTZIP */images/vendor.img */images/system.img
mv jasmine_global_images*/images/vendor.img $OUTP/vendor.img
mv jasmine_global_images*/images/system.img $OUTP/system.img
rm -rf jasmine_global_images*
 
simg2img $OUTP/system.img $OUTP/sys.img
simg2img $OUTP/vendor.img $OUTP/ven.img

printf "\n" 
printf "converting rom"
printf "\n" 

#mount imgs process
mkdir $VEN || true
mkdir $SYS || true

mount -o rw,noatime $OUTP/sys.img $SYS
mount -o rw,noatime $OUTP/ven.img $VEN

printf "\n" 
printf "starting the porting OwO"
printf "\n" 
printf "\n" 
printf "." 

#BUILD.prop editing
sed -i "/persist.vendor.camera.exif.model=/c\persist.vendor.camera.exif.model=MI 6X
/ro.product.system.model=/c\ro.product.system.model=MI 6X" $SYS/system/build.prop
sed -i "/ro.product.vendor.model=/c\ro.product.vendor.model=MI 6X" $VEN/build.prop
sed -i "/ro.product.odm.model=/c\ro.product.odm.model=MI 6X" $VEN/odm/etc/build.prop
 

printf "\n" 
printf "." 
 
#Device_Feautures
cp -f $CURRENTDIR/dualcamera.png $SYS/system/etc/
chmod 644 $SYS/system/etc/dualcamera.png
setfattr -h -n security.selinux -v u:object_r:system_file:s0 $SYS/system/etc/dualcamera.png
chown -hR root:root $SYS/system/etc/dualcamera.png

cp -f $CURRENTDIR/MIUI_DualCamera_watermark.png $VEN/etc/
chmod 644 $VEN/etc/MIUI_DualCamera_watermark.png
setfattr -h -n security.selinux -v u:object_r:system_file:s0 $VEN/etc/MIUI_DualCamera_watermark.png
chown -hR root:root $VEN/etc/MIUI_DualCamera_watermark.png

#VENDOR
cp -f $CURRENTDIR/fstab.qcom $VEN/etc/
chmod 644 $VEN/etc/fstab.qcom
setfattr -h -n security.selinux -v u:object_r:vendor_configs_file:s0 $VEN/etc/fstab.qcom
chown -hR root:root $VEN/etc/fstab.qcom

 
printf "\n" 
printf "converting to zip"
printf "\n" 

#ZIP
ROMVERSION=$(grep ro.system.build.version.incremental= $SYS/system/build.prop | sed "s/ro.system.build.version.incremental=//g"; )
sed -i "s/DEVICE/wayne/g
s/XXXXX/MI_6X/g" $OUTP/zip/META-INF/com/google/android/updater-script

umount $SYS
umount $VEN
rm -r $SYS
rm -r $VEN

DEVICE=Wayne
sudo su -c "$CURRENTDIR/last.sh $DEVICE $ROMVERSION $CURRENTUSER"


