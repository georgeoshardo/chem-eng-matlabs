%tankdesigner 2.0

clc
clear all

welcome='Welcome to Georgeos''s tank designer,';
disp(welcome)


whatisL='What is the height? L=';
L=input(whatisL);

whatisD='What is the diameter? D=';
D=input(whatisD);

whatisV='What is the volume? V=';
V=input(whatisV);

whatisL_D='What is the L/D ratio? L_D=';
L_D=input(whatisL_D);

outletprompt='What is the height of the outlet? (m)';
OH=input(outletprompt);

ullageprompt='What is the ullage? (10% = 1.1)';
ullage=input(ullageprompt);

whatisIH='What is the inactive height? IH=';
IH=input(whatisIH);


   
   %Begin calculating
if V>0 && L_D>0
    clear D
    syms D
    tempD=vpasolve(pi/4 *D^2 *L_D*D ==V*ullage,D);
    D=double(tempD(1));
    clear tempD
   
    
elseif L_D>0 && IH>0 && V>0
    clear D
    syms D;
    tempD = vpasolve(pi/4*(L_D*(D^3)-(IH*D^2))==V*ullage,D);
    D=double(tempD(1));
    clear tempD
    
elseif V>0  && L>0
    D=sqrt((V*ullage*4)/(pi*(L-OH)));
elseif L>0 && D>0
    V=(pi*D^2)/4*L;
end

%display the parameters
Dmessage=['Diameter=', num2str(D)];
Lmessage=['Height=', num2str(L)];
Vmessage=['Volume=',num2str(V*ullage)];
L_Dmessage=['L/D=',num2str(L_D)];
ullagemessage=['Ullage=',num2str(ullage)];
disp('Tank specifications:')
if V*ullage > 75
    disp('Vertical tank')
else
    disp('Horizontal tank')
end

    Vt=V*ullage;


disp(Dmessage)
disp(Lmessage)
disp(Vmessage)
disp(L_Dmessage)
disp(ullagemessage)

bundQ='Do you require a bund? 1=yes 0=no';
bundreq=input(bundQ);
if bundreq==1
    bunddistQ='How far is bund from tank? (m) ';
    bunddist=input(bunddistQ);
    bundH=Vt/((D+2*bunddist)^2);
    bundHprompt=['Bund height =', num2str(bundH), 'm'];
    disp(bundHprompt)
else
end
    

