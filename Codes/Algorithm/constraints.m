function [c,ceq] = constraints(x)
c = sum(x.^2)-3;
ceq = sum((x-0.1).^3)-2;