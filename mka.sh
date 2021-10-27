export CURRENTUSER=$(whoami)
SCRIPTDIR=$(readlink -f "$0")
CURRENTDIR=$(dirname "$SCRIPTDIR")
FIL=$CURRENTDIR/files
if [ $CURRENTUSER == root ]
then
echo "do not run as root" && exit
fi
echo "this tool port AONE jasmine rom to wayne"
echo ""
sudo chmod +x $FIL/mal.sh 
echo "Add zip rom stock to port or location"
read -p "zip:" PORTZIP
if [ "$PORTZIP" ]; then
echo
else
echo " no zip"
fi
sudo su -c "$FIL/mal.sh $PORTZIP $CURRENTUSER"
sudo mv $FIL/out/* $CURRENTDIR/
sudo chmod 777 $CURRENTDIR/AONE_Wayne*.zip -R
exit
fi



