$onend
*Max number of files should be less than 99999 otherwise naming will go wrong

*Watch out for decimals in put writing facility. filename.td=0 so entries could be rounded down
* EVENT BASED RESCHEDULING RF0 (HAS BUG: when moving horizon is shorter than rescheduling freq, more decisions
*are wrongly fixed)

$SETGLOBAL REQUEST_CPUS 1
$SETGLOBAL REQUEST_MEMORY 1024

*Following two lines decide number of points in horizon
*it is important to keep this number same across different MH lengths
*so that the same demand is sampled
*Horizon (H) is set by MH+192 in put facility below
*Used for defining end of horizon (Important to keep it same for sampling same demand)
$SETGLOBAL H 192
PARAMETER MH_max;
*PARAMETER MH_max /48/;
*remember to put a line to use smax to get automatic value for MH_max

*Number of runs per MC simulation
*Provides capability to run multiple Demand load uncertainty cases
*within one batch file, effectively reducing the number of files to manage
*Since all downstream code (MATLAB data analysis) assumes N_runs=1,
*better keep it to 1
$SETGLOBAL N_runs 1

*$include study_MH.gms
*$include study_RF.gms
*$include study_OPT.gms
*$INCLUDE study_Jan22_CTM_Email.gms
*For greedy paradox also change model to greedy objective in Model9 file
*$INCLUDE study_GreedyParadoxN1.gms
*$include study_SolutionMultiplicity.gms
*$include study_MHN3.gms
$include study_All_N2.gms
*$include study_N3_remaining.gms
SCALAR i /999999/;

FILE LinuxBatchFile /LinuxBatchFile.bat/;
FILE WindowsBatchFile /WindowsBatchFile.bat/;
FILE GamsFiles /MakeGMS.gms/;
GamsFiles.pw=255*4;
GamsFiles.nw=0;
GamsFiles.nd=0;
GamsFiles.tw=0;
GamsFiles.lw=0;

LinuxBatchFile.pw=255*4;
LinuxBatchFile.nw=0;
LinuxBatchFile.nd=0;
LinuxBatchFile.tw=0;
LinuxBatchFile.lw=0;

WindowsBatchFile.pw=255*4;
WindowsBatchFile.nw=0;
WindowsBatchFile.nd=0;
WindowsBatchFile.tw=0;
WindowsBatchFile.lw=0;

PUT LinuxBatchFile;
PUT "REQUEST_CPUS=%REQUEST_CPUS%"/;
PUT "export REQUEST_CPUS"/;
PUT "echo REQUEST_CPUS set to $REQUEST_CPUS"/;
PUT "REQUEST_MEMORY=%REQUEST_MEMORY%"/;
PUT "export REQUEST_MEMORY"/;
PUT "echo REQUEST_MEMORY set to $REQUEST_MEMORY MB"/;
*PUT 'rm *.gdx *.lst *.log *.sh *.out *.txt *.err' /;
PUT WindowsBatchFile;
PUT GamsFiles;

*$SETGLOBAL Path %gams.cdir%
*Linux_BFile.nw=0;
*Windows_BFile.nw=0;
*GAMSFiles.nw=0;
*$SETGLOBAL KEY "N.tl:2 '_' MH.tl:2 MH.te(MH) '_RF' RF.te(RF)'_' OPT.tl:4'_'DF.tl:2 DF.te(DF)'_'DV.tl:2 DV.te(DV)'_'DL.tl:2 DL.te(DL)'_'DU.tl:3 '_' S.tl:2 '_'MC.tl:2 ord(MC):0:0";
$SETGLOBAL KEY "N.tl:2 '_' MH.tl:2 par_MH(N,DF,MH) '_RF' par_RF(N,DF,RF)'_' OPT.tl'_'DF.tl:2 par_DF(N,DF)'_'DV.tl:2 par_DV(DF,DV)'_'DL.tl:2 par_DM(N,DF,DL)'_'DU.tl:3 '_' S.tl:2 '_'MC.tl:2 ord(MC):0:0 '_'Obj.tl";
*$SETGLOBAL KEY "N.tl:2 '_' MH.tl:2 par_MH(N,DF,MH) '_RF' par_RF(N,DF,RF) '_' OPT.tl:4 '_'DF.tl:2 par_DF(N,DF) '_'DV.tl:2 par_DV(DF,DV)";

SET Combinations_made(N,MH,RF,DF,DV,DL,DU,S,OPT,MC);
Combinations_made(N,MH,RF,DF,DV,DL,DU,S,OPT,MC)=NO;
parameter counter /0/;
loop N do
loop MH do
loop RF do
loop OPT do
loop DF do
loop DV do
loop DL do
loop DU do
loop S do
loop MC do
loop Obj do
*         PUT 'condor_gams Z_' %KEY%  ' '   '"../Code_Paper1/"'  /;
*         PUT 'condor_gams Z_' %KEY%  ' '   '"%gams.curdir%"'  /;
        if Allowed_MC(MC) AND comb_OBJ_DL(OBJ,DL) AND comb(N,MH,RF,OPT) AND Demand_combination(DF,DV,DL,DU,S) AND N_MH_Combination(N,MH) AND N_DL_combination(N,DL) AND N_Obj_combination(N,OBJ) then

             Combinations_made(N,MH,RF,DF,DV,DL,DU,S,OPT,MC)=YES;
             PUT LinuxBatchFile;
             i = i-1;
                 PUT 'touch "Z_'%Key%'.gdx" "Z_'%Key%'.lst" "Dummy.txt";'/;
*         PUT 'condor_gams Z_' %KEY%  ' "'    %Key%'.gms,'%Key%'.gdx,'%Key%'.lst,MasterFile.gms,Model9.gms,ModelSolution9.gms,Network1.gms,Network2.gms,Network3.gms,ConfigurationFile.gms"' /;
*         PUT 'condor_gams Z_' %KEY%  ' "Z_'    %Key%'.gms,Z_'%Key%'.gdx,MasterFile.gms,Model9.gms,ModelSolution9.gms,Network1.gms,Network2.gms,Network3.gms,ConfigurationFile.gms"' /;
                 PUT './condor_gams_dhruv.bat Z_' %KEY%  ' "Z_'    %Key%'.gms,Z_'%Key%'.gdx,Z_'%Key%'.lst,';
                 PUT 'ConfigurationFile.gms,MasterFile.gms,Model9.gms,ModelSolution9.gms,Network'N.tl'.gms" 'i';' /;
                 PUT WindowsBatchFile;
                 PUT 'gams Z_' %KEY%/;
                 PUT GamsFiles;
*         PUT %Key%/;
*         PUT 'condor_gams Z_' %KEY%  ' '   '"%gams.lo%"'  /;
                 PUT 'FILE FILENAME' @14 i:6:0 ' /Z_' %KEY% '.gms/' /;
                 PUT 'PUT FILENAME' @13 i:6:0 ';'/;
                 PUT "PUT '$SETGLOBAL NetworkNumber" @40 N.tl:2"'/;"/;
                 PUT "PUT '$SETGLOBAL MH" @40 par_MH(N,DF,MH)  "'/;"/;
                 PUT "PUT 'SCALAR re_freq" @40 '/' par_RF(N,DF,RF) '/;' "'/;"/;
                 PUT "PUT 'PARAMETER demand_cycletime" @40 '/'par_DF(N,DF)'/;' "'/;"/;
                 PUT "PUT 'PARAMETER demand_variation" @40 '/'par_DV(DF,DV) '/;' "'/;"/;
                 PUT "PUT 'PARAMETER demand_magnitude" @40 '/' par_DM(N,DF,DL):0:2 "/;'/;"/;

*            if ord(DU)=1 then
*                 PUT "PUT '$SETGLOBAL Demand_Disturbance_flag" @40 0 "'/;"/;
*            else
*                 PUT "PUT '$SETGLOBAL Demand_Disturbance_flag" @40 1 "'/;"/;
*            endif;

                 PUT "PUT 'PARAMETER lambda_Demand" @40 '/' par_DU(DL,DU):0:4 "/;'/;"/;
                 PUT "PUT 'SCALAR surprise " @40 '/' par_S(S):0:4 "/; '/;"/;
                 PUT "PUT 'SCALAR optcr_value" @40 '/'par_OPT(N,OPT):0:4'/;' "'/;"/;
                 PUT "PUT 'PARAMETER SEED_VALUE" @40 '/' seed(MC):0:0   '/;' "'/;"/;
                 PUT "PUT '$SETGLOBAL N_runs" @40 "%N_runs%'/;"/;
*         PUT "PUT '$EvalGlobal H" @40 MH.te(MH) '+%H%' "'/;"/;
                 PUT "PUT '$EVALGLOBAL H" @40 MH_max:0:0 '+%H%' "'/;"/;
                 PUT "PUT '$SETGLOBAL Results_FileName " @40  'Z_' %Key% "'/;"/;

                 if (sameas(obj,'Profit')) then
                    PUT "PUT '$SETGLOBAL OPTIMIZATION_DIRECTION " @40  ' maximizing'"'/;"/;
                    PUT "PUT '$SETGLOBAL MODEL_NAME"            @40    ' MAX_PROFIT_2 '"'/;"/;
                    PUT "PUT '$SETGLOBAL InitialInventoryBufferHours" @60     ' 12'"'/;"/;
                    PUT "PUT '$SETGLOBAL Transient_H" @40   '0 '"'/;"/;
                    PUT "PUT '$SETGLOBAL Closed_Loop_Upper" @40   ' 168 '"'/;"/;
                    PUT "PUT '$SETGLOBAL Backlog_flag" @40   ' 0 '"'/;"/;
                 endif;


                 if (sameas(obj,'Cost')) then
                    PUT "PUT '$SETGLOBAL OPTIMIZATION_DIRECTION " @40  ' minimizing '"'/;"/;
                    PUT "PUT '$SETGLOBAL MODEL_NAME"            @40    ' MIN_COST  '"'/;"/;
                    PUT "PUT '$SETGLOBAL InitialInventoryBufferHours" @60     ' 6'"'/;"/;
                    PUT "PUT '$SETGLOBAL Transient_H" @40   ' 0 '"'/;"/;
                    PUT "PUT '$SETGLOBAL Closed_Loop_Upper" @40   ' 168'"'/;"/;
                   PUT "PUT '$SETGLOBAL Backlog_flag" @40   ' 1 '"'/;"/;
*                    PUT "PUT '$SETGLOBAL InitialInventoryFlag" @40     ' 0'"'/;"/;
*                    PUT "PUT '$SETGLOBAL Transient_H" @40   ' 48 '"'/;"/;
*                    PUT "PUT '$SETGLOBAL Closed_Loop_Upper" @40   ' 192'"'/;"/;
                 endif;

                 PUT "PUT '$SETGLOBAL Gantt_OL_Number       1'/;"/;
                 PUT "PUT '$INCLUDE ConfigurationFile.gms'/;"/;
                 PUT /;
                 counter=counter+1;
        endif;
endloop;
endloop;
endloop;
endloop;
endloop;
endloop;
endloop;
endloop;
endloop;
endloop;
endloop;

display counter;
EXECUTE_UNLOAD 'MakeBatchFiles.gdx'
*END of MakeBatchFiles file


