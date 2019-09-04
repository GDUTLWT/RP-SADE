function [P1,P2,P3,P4] = cal_STA_pro_0318(SUC,FAI,k_index,LP)

if  k_index==1
    bf_k_index = LP;
else
    bf_k_index = k_index-1;
end
epsilo = 0.01;
S_SUM_L = sum(SUC,1);
F_SUM_L = sum(FAI,1);


if  SUC(k_index,1)/(SUC(k_index,1)+FAI(k_index,1))>=SUC(bf_k_index,1)/(SUC(bf_k_index,1)+FAI(bf_k_index,1))
    S1 = SUC(1)/(SUC(1)+F_SUM_L(1))+epsilo;
else 
    S1 = S_SUM_L(1)/(S_SUM_L(1)+F_SUM_L(1))-epsilo;
end
S1 = min(1,S1);
S1 = max(0,S1);
    
if  SUC(k_index,2)/(SUC(k_index,2)+FAI(k_index,2))>=SUC(bf_k_index,2)/(SUC(bf_k_index,2)+FAI(bf_k_index,2))
    S2 = S_SUM_L(2)/(S_SUM_L(2)+F_SUM_L(2))+epsilo;
else
    S2 = S_SUM_L(2)/(S_SUM_L(2)+F_SUM_L(2))-epsilo;
end
S2 = min(1,S2);
S2 = max(0,S2);

if  SUC(k_index,3)/(SUC(k_index,3)+FAI(k_index,3))>=SUC(bf_k_index,3)/(SUC(bf_k_index,3)+FAI(bf_k_index,3))
    S3 = S_SUM_L(3)/(S_SUM_L(3)+F_SUM_L(3))+epsilo;
else
    S3 = S_SUM_L(3)/(S_SUM_L(3)+F_SUM_L(3))-epsilo;
end
S3 = min(1,S3);
S3 = max(0,S3);

if  SUC(k_index,4)/(SUC(k_index,4)+FAI(k_index,4))>=SUC(bf_k_index,4)/(SUC(bf_k_index,4)+FAI(bf_k_index,4))
    S4 = S_SUM_L(4)/(S_SUM_L(4)+F_SUM_L(4))+epsilo;
else
    S4 = S_SUM_L(4)/(S_SUM_L(4)+F_SUM_L(4))-epsilo;
end
S4 = min(1,S4);
S4 = max(0,S4);

if  isnan(S1)
    S1 = epsilo;
end
if  isnan(S2)
    S2 = epsilo;
end
if  isnan(S3)
    S3 = epsilo;
end
if  isnan(S4)
    S4 = epsilo;
end

total_S = S1+S2+S3+S4;

if total_S == 0
    P1 = 1/4;
    P2 = 1/4;
    P3 = 1/4;
    P4 = 1/4;   
else
    P1 = S1/total_S;
    P2 = S2/total_S;
    P3 = S3/total_S;
    P4 = S4/total_S;
end
end