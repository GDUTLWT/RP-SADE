function [sta_type2,sta_type1] = dec_sta_type(P1,P2,P3,P4,type,LP)
switch type
    case 1
        alphabet = [1 2 3 4];
        prob = [1/4,1/4,1/4,1/4];
        sta_type1 = randsrc(LP,1,[alphabet; prob]);   
        sta_type2 = 0;
    case 2    
        alphabet = [1 2 3 4];
        prob = [P1 P2 P3 P4];
        sta_type1 = 0;
        sta_type2 = randsrc(1,1,[alphabet; prob]);



end