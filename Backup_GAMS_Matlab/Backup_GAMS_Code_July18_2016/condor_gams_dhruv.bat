#!/bin/bash
# first argument is a file containing list of gams statements
#   or the name of the gams job to run (e.g. trnsport to run gams trnsport)
# second optional argument is a "quoted" comma separated list of files to be transferred over
# third optional argument is a number to use for labeling output
# eg condor_gams trnsport.run "trnsport.gms,foo.gms"
# or condor_gams trnsport
# or condor_gams trnsport trnsport.gms
# or condor_gams trnsport trnsport.gms 1

if [ -z $REQUEST_CPUS ]; then
  REQUEST_CPUS=1
fi
if [ -z $REQUEST_MEMORY ]; then
  REQUEST_MEMORY=1024
fi

if [ -n "${3}" ]; then
  id=${3};
else
  id=$$;
fi
echo "universe = vanilla"   > gams$id.cmd
echo "executable = runit$id.sh" >> gams$id.cmd
echo "error = gams$id.err" >> gams$id.cmd
echo "output = gams$id.out" >> gams$id.cmd
echo "log = gams$id.log" >> gams$id.cmd
echo "match_list_length = 5" >> gams$id.cmd
echo "Notification = NEVER" >> gams$id.cmd
echo "+threshold_hours = 6"  >> gams$id.cmd
echo "should_transfer_files = YES" >> gams$id.cmd
if [ -n "${2}" ]; then
  echo "transfer_input_files = ${2}" >> gams$id.cmd
elif [ -e ${1}.gms ]; then
  echo "transfer_input_files = ${1}.gms" >> gams$id.cmd
else
  echo "no input file found";
  exit;
fi
echo "when_to_transfer_output = ON_EXIT" >> gams$id.cmd
echo "+InteractiveJob = FALSE"  >> gams$id.cmd
echo "request_cpus = ${REQUEST_CPUS}" >> gams$id.cmd
#echo "request_memory = 1024" >> gams$id.cmd
echo "request_memory = ${REQUEST_MEMORY}" >> gams$id.cmd
echo '+Group = "WID"'  >> gams$id.cmd
echo '+WIDsTheme = "Optimization"' >> gams$id.cmd
echo "skip_filechecks = true" >> gams$id.cmd
echo "queue" >> gams$id.cmd

echo "#!/bin/bash"              > runit$id.sh
echo 'export PATH="/extra/app/gams:$PATH"'   >> runit$id.sh
echo 'export LD_LIBRARY_PATH="/extra/app/gams:$LD_LIBRARY_PATH"'   >> runit$id.sh
#echo 'echo $HOSTNAME' >> runit$id.sh
if [ -e ${1} ]; then
  cat ${1} >> runit$id.sh
else
  echo "gams " ${1} >> runit$id.sh
fi
chmod +x runit$id.sh;

echo ${1} "	" $id >> JobIDs.log

condor_submit gams$id.cmd;
