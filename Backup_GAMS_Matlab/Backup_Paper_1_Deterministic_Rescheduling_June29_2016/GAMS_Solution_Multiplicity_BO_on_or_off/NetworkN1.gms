SETS     i tasks  /T1*T2/
         s states /M1*M3/
         j units  /U1/
         u utilities /manpower/

*         Ki(j,i) set of equipments(units) suitable for task i
*         /(Reactor1).(TA,TB),Heater.Heating/
         Ij(i,j) set of equipments(units) suitable for task i
         /(T1,T2).U1/

         FIS(s) States with Finite Intermediate Storage /M1*M3/
         product_states(s) Product States/M2*M3/
         feed_states(s) Feed States/M1/

         UtilInt Intervals for utility /Int1/
         UnitInt Intervals for unit-unavailability /Int1/

         Attributes/magnitude, starttime, price/
;

Table UtilData(UtilInt,u,Attributes)
             manpower.starttime            manpower.magnitude      manpower.price
Int1                    0                         10                     0
;

*Availability of unit  0=available, 1=not available
Table UnitData(UnitInt,j,Attributes)
              U1.magnitude         U1.starttime
Int1              0                     0
;

Parameters rho(i,s) proportion of input of task i from states s
           /T1.M1 1,T2.M1 1/
           rhobar(i,s) proportion of ouput of task i to state s
           /T1.M2 1, T2.M3 1/

           pis(i,s) processing time for output of task i into state s
           /T1.M2 2,T2.M3 3/
           pi(i) maximum processing time in task i for any stage produced by it

           alpha(u,i) fixed utility demand by task i throughout its run
           /manpower.(T1*T2) 0/
           beta(u,i) "variable utility demand by task i throughout its run(te/hr)"
           /manpower.(T1*T2) 0/

           vmaxij(i,j)  Maximum capacity of unit j when used for task i
           /(T1,T2).(U1) 10/
           vminij(i,j)  Minimum capacity of unit j when used for task i
           /(T1,T2).(U1) 1/
           Cs(s) maximum storage capacity for stage s  /(M1*M3) 99999/
           Cst(s) unit price of s/M1 1, M2 10, M3 10/
;
*pis(i,s)=5;
pi(i)=smax(s,pis(i,s));




*END OF INSTANCE FILE
*parameter deliveries_time_varied(o);















$ontext
Table deliveries(o,s)
        SA      SB
o1      5       5
o2      5       5
o3      5       5
o4      5       5
o5      5       5
o6      5       5
o7      5       5
o8      5       5;
$offtext


$ontext
For debugging/testing utility formulas
Table UtilData(UtilInt,u,Attributes)
             manpower.starttime            manpower.magnitude      manpower.price
Int1                    0                         1                     1
Int2                    1.5                       0                     0
Int3                    3.5                       1                     1
Int4                    6.1                       0                     0;
$offtext
