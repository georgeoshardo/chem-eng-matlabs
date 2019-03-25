clc
clear all

a=200;
b=150;
c=115;
A=a/c;
B=b/a;
X=A*(1+B);
Y=A*(1-B);
Multiplier=(1/(pi*A^2));
Line1= log(((A^2 * (1+B^2) + 2)^2)/((Y^2 + 2)*(X^2+2)));
Line2=(Y^2 + 4)^(1/2) * (Y* atan(Y/((Y^2+4)^(1/2))) - X* atan(X/((Y^2+4)^(1/2))));
Line3=(X^2 + 4)^(1/2) * (X* atan(X/((X^2+4)^(1/2))) - Y* atan(Y/((X^2+4)^(1/2))));

viewfactor=Multiplier*(Line1+Line2+Line3)