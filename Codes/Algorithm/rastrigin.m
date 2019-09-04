function [f] = rastrigin(x)
global nfe
nfe = nfe+1;
fi = x.^2-10*cos(2*pi*x);
f = sum(fi)+10;
% g = 2*x+10*sin(2*pi*x)*2*pi;
% pause(1);
