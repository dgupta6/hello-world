%Machines.Operators example of statistics book
%Dhruv Gupta
%April 3, 2016
clear
clc 

data=[53 61 51
      47 55 51
      46 52 49
      50 58 54
      49 54 50];
  
[p,tbl,stats] = anova2(data,1,'off')

