rm Z_* *.log *.sh *.out *.txt *.err *.cmd *.put;
gams MakeBatchFiles.gms;
gams MakeGMS.gms;
sed -i 's/\r$//' LinuxBatchFile.bat;
#sed -i ':a;$ s/lst\,\n/lst\,/g;N;ba' LinuxBatchFile.bat;
chmod +x *.bat;
./LinuxBatchFile.bat | tee clusterIDs.log
