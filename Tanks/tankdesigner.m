%Georgeos's tank designer

clc
clear all

welcome='Welcome to Georgeos''s tank designer, please follow the instructions to design a tank! What variables do you have?';
disp(welcome)


whatisL='What is the height? L=';
L=input(whatisL);

whatisD='What is the diameter? D=';
D=input(whatisD);

whatisV='What is the volume? V=';
V=input(whatisV);

whatisL_D='What is the L/D ratio? L_D=';
L_D=input(whatisL_D);

whatisIH='What is the inactive height? IH=';
IH=input(whatisIH);

if V>0 & L>0
    outletprompt='What is the height of the outlet? (m)';
    outletheight=input(outletprompt);
    D=sqrt((V*1.1*4)/(pi*(L-outletheight)));
    L_D=(L/D)
    tankdiametermessage=['The tank diameter was calculated to be ', num2str(D), 'm, and the L/D ratio is ', num2str(L_D)];
    disp(tankdiametermessage)
elseif V>0 & L>0 & IH>0
    
end









%Code for known volume and height
liquidvolumeprompt='Enter the volume of liquid to be stored (m^3) (no ullage) ';
liquidvolume=input(liquidvolumeprompt);
totalvolume=liquidvolume*1.1;
totalvolumemessage=['The total volume including ullage is ', num2str(totalvolume), 'm'];
disp(totalvolumemessage)

if totalvolume > 75
    verticaltank='You should be desigining a vertical tank!';
    disp(verticaltank);
else
    horizontaltank='You should be designing a horizontal tank!';
    disp(horizontaltank)
end

heightprompt='Enther the total height of the tank (m) ';
height=input(heightprompt);

outletprompt='What is the height of the outlet? (m)';
outletheight=input(outletprompt);

tankdiameter=sqrt((totalvolume*4)/(pi*(height-outletheight)));

tankdiametermessage=['The tank diameter was calculated to be ', num2str(tankdiameter), 'm'];
disp(tankdiametermessage)