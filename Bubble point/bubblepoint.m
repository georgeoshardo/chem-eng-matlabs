clc
clear all

AB=4.72583;
BB= 1660.652;
CB=-1.461;

AT=4.07827;
BT=1343.943;
CT=-53.773;
syms T
eqn1=(10^(AB-BB/(CB+T))*0.72)+(10^(AT- BT/(CT+T))*0.28)==2.16
sol=solve([eqn1],[T]);
Tsol=sol.T

