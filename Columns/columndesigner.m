clc
clear all

%%Rules of thumb
%Height 30m, sometimes up to 50m
%Diameter 1-9m
%Trays 0.45 to 0.6m apart
%Top: Allow 1 tray space + 0.15m then dome
%Bottom: Allow 1 tray space + 0.15m then pool of 5-10 min of liquid.
%Pg 567

%HK and LK parameters
%Heavy key is TOLUENE
%Light key is BENZENE

mmHK =  92.14/1000; %Molar mass of heavy key TOLUENE(kg/mol)
mmLK = 78.11/1000; %Molar mass of light key BENZENE (kg/mol)

bptHK = 110.6+273; %Heavy key boiling point (K)
bptLK = 80.1+273; %Light key boiling point (K)


%Input parameters
Fm=9.72222222222222; %mass feed rate (kg/s)

xF = 0.72; %Mole fraction of MVC
xD = 0.998; %Mole fraction of distillate
xB = 0.005; %Mole fraction of bottoms

%convert mass to mole fraction
basis=100; %taking 100 mole basis
F_LK=basis*xF; %find molar flow rate of light key
F_HK=basis*(1-xF); %find molar flow rate of heavy key

Bamdot_LK=F_LK*mmLK; %mass flow rate of LK FEED BASIS
Bamdot_HK=F_HK*mmHK; %mass flow rate of HK BASIS
BamdotFeed=Bamdot_LK+Bamdot_HK; %total mass flow rate BASIS
massfracLK=Bamdot_LK/BamdotFeed; % mass frac of LK
massfracHK=Bamdot_HK/BamdotFeed; %mass frac of HK

Fmdot_LK=massfracLK*Fm;
Fmdot_HK=massfracHK*Fm;

FmoleflowLK=Fmdot_LK/mmLK;
FmoleflowHK=Fmdot_HK/mmHK;

F=FmoleflowLK+FmoleflowHK; %Feed rate (mol/s)

%Getting top and bottom flow rates mole/mass



%alpha numbers for Fenskey's 
alphatop = 2.5; %alpha at top
alphabottom = 10; %alpha at bottom 
alphafeed = 5; %alpha at feed

Nmtop=(log10((xD/(1-xD))*((1-xF)/xF)))/(log10((alphatop+alphafeed)/2)); %top number of stages based on fensky
Nmbot=(log10((xF/(1-xF))*((1-xB)/xB)))/log10((alphabottom+alphafeed)/2); %bottom number of stages based on fensky
Nmin=Nmbot+Nmtop; %total minimum theoretical stages

trayspacing = 0.6; %specifying the distance between plates (m)

%finding minimum reflux ratio
Rmin=(1/(alphafeed-1))*((xD/xF)-alphafeed*((1-xD)/(1-xF))); %minimum reflux ratio (BUBBLE POINT FEED ONLY)
Rminmultiplier = 1.2; %usually 1.2-1.5
Ract=Rmin*Rminmultiplier;

%Gilliland Correlation
GCx=(Ract-Rmin)/(Ract+1); %x axis of Gilliland correlation pg 10 in notes
GCy=0.6; %FROM THE GRAPH READ THE FUCKING GrAPH pg 10 in notes

Nact=(-Nmin-GCy)/(GCy-1); %total number of plates needed (from gilliland) assuming 100% efficiency

%distillate and bottoms flow rates by sim equations
syms D B
eqn1=F*xF == D*xD + B*xB;
eqn2=F*(1-xF)== D*(1-xD) + B*(1-xB);
sol=solve([eqn1,eqn2],[D, B])
Dsolsym=sol.D
Bsolsym=sol.B
Dsol=double(Dsolsym);
Bsol=double(Bsolsym);
%Flooding considerations for top and bottom of column
rhoV=5.7;
rhoL=861.5;
%flooding consideration top
mdotD=(Dsol*xD)*mmLK + (Dsol*(1-xD))*mmHK; %converting distillate to mass flow
mdotB=(Bsol*xB)*mmLK + (Bsol*(1-xB))*mmHK; %converting bottoms to mass flow


Lwtop=Ract*mdotD; %mass liquid rate above feed (kg/s)
Lwbot=Lwtop+Fm; %mass liquid rate below feed (kg/s)

Vwtop=mdotD+Lwtop; %vapor rate above feed (kg/s)
Vwbot=Lwbot-mdotB; %vapor rate below feed (kg/s)

FLVtop=(Lwtop/Vwtop)*sqrt(rhoV/rhoL) %Need this for graph on pg 15 notes (top)
FLVbot=(Lwbot/Vwbot)*sqrt(rhoV/rhoL) %Need this for graph on pg 15 notes (bottom)

K1top=1.25*10^-1; %From graph on pg 15
K1bot=10^-1;       %From graph on pg 15

uftop=K1top*sqrt((rhoL-rhoV)/rhoV);
ufbot=K1bot*sqrt((rhoL-rhoV)/rhoV);

holedia=5/1000; %hole diameter
percentuf=0.8; %percentage of flooding velocity;


