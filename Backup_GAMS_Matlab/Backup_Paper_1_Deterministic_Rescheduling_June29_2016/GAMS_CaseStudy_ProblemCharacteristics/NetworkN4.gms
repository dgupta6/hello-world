Sets     i tasks  /T1*T4/
         s states /M1*M5/
         j units  /U1*U3/
         u utilities /manpower/

*         Ki(j,i) set of equipments(units) suitable for task i
*         /(Reactor1).(TA,TB),Heater.Heating/
         Ij(i,j) set of equipments(units) suitable for task i
         /T1.U1,(T2*T4).(U2*U3)/

         FIS(s) States with Finite Intermediate Storage /M1*M2/
         product_states(s) Product States/M3*M5/
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
           /T1.M1 1,(T2*T4).M2 1/
           rhobar(i,s) proportion of ouput of task i to state s
           /T1.M2 1, T2.M3 1, T3.M4 1, T4.M5 1/

           pis(i,s) processing time for output of task i into state s
           /T1.M2 3, T2.M3 3, T3.M4 4, T4.M5 4/
           pi(i) maximum processing time in task i for any stage produced by it

           alpha(u,i) fixed utility demand by task i throughout its run
           /manpower.(T1*T4) 0/
           beta(u,i) "variable utility demand by task i throughout its run(te/hr)"
           /manpower.(T1*T4) 0/

           vmaxij(i,j)  Maximum capacity of unit j when used for task i
           /T1.U1 20, (T2,T3,T4).(U2,U3) 10/
           vminij(i,j)  Minimum capacity of unit j when used for task i
           /T1.U1 10, (T2,T3,T4).(U2,U3) 5/
           Cs(s) maximum storage capacity for stage s  /(M1*M5) 99999/
           Cst(s) unit price of s/M1 1, M2 5, M3 10, M4 10, M5 10/
;
*pis(i,s)=5;
pi(i)=smax(s,pis(i,s));

$ontext
******DEMAND INFORMATION*****************************
*Each order for all products
set         o orders /o1*o%H%/;
parameter deliveries_time(o);
deliveries_time(o)=demand_cycletime*ord(o);
deliveries_time(o)=deliveries_time(o)+UniformInt(-demand_variation,demand_variation);
parameter deliveries(o,s);
deliveries(o,s)$(product_states(s))=demand_magnitude;
******DEMAND INFORMATION*****************************
$offtext

*END OF INSTANCE FILE
















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
