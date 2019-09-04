clear 
clc
a = load('c11_X_CEC18.mat');
a = struct2cell(a);
a = cell2mat(a);
global I_fno initial_con_flag
initial_con_flag = 0;
I_fno = 11;
[g,h] = CEC2017non(a);
