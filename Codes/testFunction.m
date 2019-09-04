clear all;
clc
format long e;
x =ones(30,1);
global initial_flag I_fno initial_fun_flag initial_con_flag nfe;
nfe = 0;
for i=1:28
   I_fno = i; 
   initial_flag = 0;
   initial_con_flag = 0;
   initial_fun_flag = 0;
   [f,g,h]=CEC2017(x');
   f1=CEC2017fun(x');
   [g1,h1]=CEC2017non(x');
   testa = nfe;

end
