clc
clear all

%Cold fluid properties - Also tube fluid
mdotC=35000/3600;
TCin=15+273;
TCout=386.338;
PCin=(2+1)*10^5;
CpC=1864;
deltaTC=TCout-TCin;
rhoC=831.035;
muC=4.6275*10^(-4);

Cpt=CpC;
rhoT=rhoC;
muT=muC;

TCavg=(TCin+TCout)/2;
%Hot fluid properties - Also shell side


THin=412.7497528+30;
THout=412.7497528+30;
PHin=(3+1)*10^5;
CpH=2456.09; %from http://www2.spiraxsarco.com/esc/SS_Properties.aspx?lang_id=ENG&country_id=US
deltaTH=THin-THout;
rhoH=4.08048; %NOT NEEDED
rhoS=rhoH;
CpS=CpH;
muH=1.4666666*10^(-5); %viscosity of steam at temp 
muS=muH;
deltaHVap=2050.52*1000; %enthalpy of vap of steam J/kg


%Find LMTD
LMTDnum=(THin-TCout)-(THout-TCin);
LMTDden=log((THin-TCout)/(THout-TCin));
LMTD=LMTDnum/LMTDden;

%pass count
p=2;

%HX duty
Q=CpC*mdotC*deltaTC; %in J/s

%Find HOT (steam) fluid flow rate
mdotH=Q/deltaHVap;

%Finding R and S
R=(THin-THout)/(TCout-TCin);
S=(TCout-TCin)/(THin-TCin);
Fprompt=['What is Ft from graph (pg 657)? ','R=',num2str(R), ' S=',num2str(S),' '];
Ft=input(Fprompt);


for k=1:30
%Initial guess for U
uvalues(1)=600;
U=uvalues(k);



%Prelim area
A=Q/(U*Ft*LMTD);



%Define tubes
OD=20/1000;     %Outer diameter
tp=2/1000;       %Thickness
Lp=4.88;        %Length per pipe
ID=OD-(2*tp);   %Inner diameter
Icsa=pi*(ID^2)/4;   %Internal cross sectional area

%Tubes
SA1=pi*OD*Lp;   %Surface area of 1 tube
nt=A/SA1       %number of tubes
np=nt/p;        %Number of tubes per pass
vt=mdotC/(rhoT*Icsa*np) %tube velocity

%Tube side coefficients
Ret= (rhoT*vt*ID)/muC;  %Tube side reynold's number
jtprompt=['What is TS J factor (pg 665)? TS Re=',num2str(Ret),' ']; %prompt user to input j factor
jt=input(jtprompt);              %j factor from graph
kf = 0.28*(-0.0002*TCavg+0.1939)+0.72*3.9674*TCavg^(-0.584)   %Thermal conductivity of pipe fluid (engtoolbox)
Prt=(Cpt*muT)/kf       %Tube side prantl number
hi=jt*Ret*(Prt^0.33)*(kf/ID)*(muT/0.001)^0.14 %estimating heat inner tube heat transfer coefficient from corrolation 

%Shell side coefficients
pt=1.25*OD;      %tube pitch for square pitch
K1=0.249;       %K and n from table 12.4 in C&R Vol6
n1=2.207;
BD=OD*(nt/K1)^(1/n1) %Bundle diameter equation
%%SOME OF THE FOLLOWING LINES HAVE BEEN COMMENTED OUT
%%THIS IS BECAUSE IN THE CASE OF A PHASE CHANGE, KERNS METHOD 
%%IS NOT VALID. INSTEAD A VALUE FOR hs=8000 IS ASSUMED
%tB=0.052 ;       %Bundle thickness from fig12.10 pg 646 C&R Vol6
%SD=BD+tB;       %Shell diameter
%BS=SD/5;         %Assume 5 baffles for baffle spacing
%	=((pt-OD)*SD*BS)/pt;  %crossflow area
%vs= mdotH/(As*rhoS);    %shell side velocity
%de=1.27/OD * (pt^2 - 0.917*OD^2);   %equivilent diameter
%Res=(vs*rhoS*de)/muS;       %Shell side reynolds number
kfs=0.0323;                   %shell side conductivity (engtoolbox)
%Prs=CpS*muS/kfs;             %Shell side prantl number
%jsprompt=['What is SS J factor (pg 673)? SS Re=',num2str(Res),' ']; %prompt the user to input j factor
%js=input(jsprompt);               %shell side j factor from graph
hs=8000; %kfs/de *js*Res*Prs^(1/3)*(muS/0.001)^(0.14);  %shell side heat transfer coefficient

%Fouling factors from table pg 640 C&R vol6
fs=7000;
ft=5000;

kp=45; %thermal conductivity of tube

invU=1/8000 + 1/fs + (1/hi + 1/ft)*(OD/ID) + tp/kp %calculating overall HTC
Uk=1/invU;

uvalues(k+1)=Uk;
uvalueprompt=['U= ', num2str(Uk)];

%pointwise plot graphs!!
hold on
subplot(2,2,1), plot(k,U,'o')
ylabel('U / W/m^2 K')
xlabel('Iteration number')
hold on
subplot(2,2,2), plot(k,A,'o')
ylabel('A / m^2')
xlabel('Iteration number')
hold on
subplot(2,2,3), plot(k,Ret,'o')
ylabel('TS Re')
xlabel('Iteration number')
hold on
%subplot(2,2,4), plot(k,Res,'o')
%ylabel('SS Re')
subplot(2,2,4), plot(k,nt,'o')
ylabel('Number of tubes')
xlabel('Iteration number')

end

%Tube side pressure drop
jpdt=0.003; %from graph handout page 22 (jpdt = j pressure drop tube)
vh_p=2.5; %velocity head per pass C&R 
deltaPt=p*(8*jpdt*(Lp/ID)*(muT/0.001)^(-0.14)+vh_p)*((rhoT*vt^2)/2)

%Shell side pressure drop
%jpds=5*10^(-2);   %from graph handout page 24 j factor pressure drop shell side
%deltaPs=8*jpds*((SD/de)*(Lp/BS)*((rhoS*vs^2)/2)*(muS/0.001)^(-0.14))
