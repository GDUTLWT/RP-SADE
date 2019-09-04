clear;
clc
addpath(genpath(pwd));
format long e;
nVar = 30;
Fval = zeros(25,1);
NFE = zeros(25,1);
X_paper = zeros(30,25);
Eq_con_flag = [0,0,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,0,0,0,0,1,1,1,1,1,0];
LB_UB = [100,100,100,10,10,20,50,100,10,100,100,100,100,100,100,100,100,100,50,100,100,100,100,100,100,100,100,50];
global initial_flag I_fno initial_fun_flag initial_con_flag nfe;
for j = 1:5
    I_fno = j; 
    initial_flag = 0;
    initial_con_flag = 0;
    initial_fun_flag = 0;
    eq_con_flag = Eq_con_flag(j);
    lb1 = -1*ones(nVar,1)*LB_UB(j);
    ub1 = ones(nVar,1)*LB_UB(j);
    for i = 1:25
        nfe = 0;
        [x1,fval1,output1]=test_CEC0819(nVar,@CEC2017fun,lb1,ub1,@CEC2017non,eq_con_flag);
        nfe1 = nfe;
        Fval(i,1) = fval1;
        NFE(i,1) = nfe1;
        X_paper(:,i) = x1;
    end

    % xlswrite('C:\Users\Administrator\Desktop\Data\c1\c01_fval',Fval)
    % xlswrite('C:\Users\Administrator\Desktop\Data\c1\c01_nfe',NFE)
    % xlswrite('C:\Users\Administrator\Desktop\Data\c1\c01_X_paper',X_paper)
    if j ==1
        save c01_fval_CEC0716 Fval
        save c01_nfe_CEC0716 NFE 
        save c01_X_paper_CEC0716 X_paper 
        Fval = zeros(25,1);
        NFE = zeros(25,1);
        X_paper = zeros(30,25);
    end
    
    if j ==2
        save c02_fval_CEC0716 Fval
        save c02_nfe_CEC0716 NFE 
        save c02_X_paper_CEC0716 X_paper 
        Fval = zeros(25,1);
        NFE = zeros(25,1);
        X_paper = zeros(30,25);
    end
    
    if j ==3
        save c03_fval_CEC0716 Fval
        save c03_nfe_CEC0716 NFE 
        save c03_X_paper_CEC0716 X_paper 
        Fval = zeros(25,1);
        NFE = zeros(25,1);
        X_paper = zeros(30,25);
    end
    
    if j ==4
        save c04_fval_CEC0716 Fval
        save c04_nfe_CEC0716 NFE 
        save c04_X_paper_CEC0716 X_paper 
        Fval = zeros(25,1);
        NFE = zeros(25,1);
        X_paper = zeros(30,25);
    end
    
    if j ==5
        save c05_fval_CEC0716 Fval
        save c05_nfe_CEC0716 NFE 
        save c05_X_paper_CEC0716 X_paper 
        Fval = zeros(25,1);
        NFE = zeros(25,1);
        X_paper = zeros(30,25);
    end
               
end
