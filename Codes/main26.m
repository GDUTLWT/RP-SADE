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
for j = 26:28
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
    if j ==26
        save c26_fval_CEC0716 Fval
        save c26_nfe_CEC0716 NFE 
        save c26_X_paper_CEC0716 X_paper 
        Fval = zeros(25,1);
        NFE = zeros(25,1);
        X_paper = zeros(30,25);
    end
    
    if j ==27
        save c27_fval_CEC0716 Fval
        save c27_nfe_CEC0716 NFE 
        save c27_X_paper_CEC0716 X_paper 
        Fval = zeros(25,1);
        NFE = zeros(25,1);
        X_paper = zeros(30,25);
    end
    
    if j ==28
        save c28_fval_CEC0716 Fval
        save c28_nfe_CEC0716 NFE 
        save c28_X_paper_CEC0716 X_paper 
        Fval = zeros(25,1);
        NFE = zeros(25,1);
        X_paper = zeros(30,25);
    end
 
end
