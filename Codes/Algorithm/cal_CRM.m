function [CRM1,CRM2,CRM3,CRM4] = cal_CRM(CR_Mem)

CRM1 = sum(CR_Mem(:,2).*CR_Mem(:,1))/sum(CR_Mem(:,2));
CRM2 = sum(CR_Mem(:,4).*CR_Mem(:,3))/sum(CR_Mem(:,4));
CRM3 = sum(CR_Mem(:,6).*CR_Mem(:,5))/sum(CR_Mem(:,6));
CRM4 = sum(CR_Mem(:,8).*CR_Mem(:,7))/sum(CR_Mem(:,8));

end