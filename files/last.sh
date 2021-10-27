CURRENTUSER=$3
DEVICE=$1
ROMVERSION=$2
SCRIPTDIR=$(readlink -f "$0")
CURRENTDIR=$(dirname "$SCRIPTDIR")
OUTP=$CURRENTDIR/out


img2simg $OUTP/sys.img $OUTP/sparsesystem.img
sudo rm $OUTP/sys.img
$CURRENTDIR/img2sdat/img2sdat.py -v 4 -o $OUTP/zip -p system $OUTP/sparsesystem.img
sudo rm $OUTP/sparsesystem.img
img2simg $OUTP/ven.img $OUTP/sparsevendor.img
sudo rm $OUTP/ven.img
$CURRENTDIR/img2sdat/img2sdat.py -v 4 -o $OUTP/zip -p vendor $OUTP/sparsevendor.img
sudo rm $OUTP/sparsevendor.img
brotli -j -v -q 6 $OUTP/zip/system.new.dat
brotli -j -v -q 6 $OUTP/zip/vendor.new.dat

cd $OUTP/zip
zip -ry $OUTP/AONE_$DEVICE-$ROMVERSION.zip *
cd $CURRENTDIR
rm -rf $OUTP/zip
chown -hR $CURRENTUSER:$CURRENTUSER $OUTP

