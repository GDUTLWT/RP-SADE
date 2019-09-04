function F_type_array = dec_F_type(F_SUC_Mem,F_FAI_Mem,BEF_F)

F_type_array = BEF_F;

total_1 = sum(F_SUC_Mem(:,1)+F_FAI_Mem(:,1));
total_2 = sum(F_SUC_Mem(:,2)+F_FAI_Mem(:,2));
total_3 = sum(F_SUC_Mem(:,3)+F_FAI_Mem(:,3));
total_4 = sum(F_SUC_Mem(:,4)+F_FAI_Mem(:,4));

p(1) = sum(F_SUC_Mem(:,1))/total_1;
p(2) = sum(F_SUC_Mem(:,2))/total_2;
p(3) = sum(F_SUC_Mem(:,3))/total_3;
p(4) = sum(F_SUC_Mem(:,4))/total_4;

for i =1:4
    if p(i)<0.5
        if  BEF_F(i)==0.65
            F_type_array(i) = 0.35;
        else
            F_type_array(i) = 0.65;
        end
    end
end
end