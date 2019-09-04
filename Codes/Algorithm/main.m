clear
clc
% global dmodel objfunc S Y theta lob upb
global nfe

for N = 1:1


    nfe = 0;

    noncon = @constraints;
    objfunc = @rastrigin;

    nVar = 3;
    lb = -3*ones(nVar,1);
    ub = 3*ones(nVar,1);

    % A = [-1 2 -3 1 3;2 -1 2 -2 1];
    % b = [1;1];
    % Aeq = [-1 2 -3 -1 2];
    % beq = [2];
    % x0 = [3;3;4;4;-4];

    A = [2 1 3];
    b = [0];
    Aeq = [1 1 1];
    beq = [1];

    % x0 = [0;0;0];
% %     x0 = rand(nVar,1).*(ub-lb)+lb;
% %     [x1,fval1,output] = fmincon(objfunc,x0,A,b,Aeq,beq,lb,ub,noncon);
% %     nfe1 = nfe;
% % 
% %     if ~isempty(b)
% %     d1 = A*x1-b;
% %     end
% %     if ~isempty(beq)
% %     deq1 = Aeq*x1-beq;
% %     end
% %     if ~isempty(noncon)
% %     [c1,ceq1] = noncon(x1);
% %     end
% % 
% %     nfe = 0;
% %     x2 = x0;
% %     goptions = gaoptimset(@ga);
% %     goptions = gaoptimset(goptions,'PopulationSize',100,'MutationFcn',@mutationadaptfeasible,'Display','iter');
% %     [x2,fval2,output1] = ga(objfunc,nVar,A,b,Aeq,beq,lb,ub,noncon,goptions);
% %     x2 = x2';
% %     nfe2 = nfe;
% % 
% %     if ~isempty(b)
% %     d2 = A*x2-b;
% %     end
% %     if ~isempty(beq)
% %     deq2 = Aeq*x2-beq;
% %     end
% %     if ~isempty(noncon)
% %     [c2,ceq2] = noncon(x2);
% %     end
% % 
    % % 模型参数设置
%     nfe = 0;
%     options = deoptions;
%     options.surrogate = 0;
%     
%     x3 = de(nVar,objfunc,A,b,Aeq,beq,lb,ub,noncon,options);
%       
%     if ~isempty(b)
%     d3 = A*x3-b;
%     end
%     if ~isempty(beq)
%     deq3 = Aeq*x3-beq;
%     end
%     if ~isempty(noncon)
%     [c3,ceq3] = noncon(x3);
%     end
%     fval3 = objfunc(x3);        
%     nfe3 = nfe;
 
    % % 模型参数设置
    nfe = 0;
    options = deoptions;
    options.surrogate = 0;    
    x4 = test_Li_kring_SADE0407(nVar,objfunc,A,b,Aeq,beq,lb,ub,noncon,options);
    
      
    if ~isempty(b)
    d4 = A*x4-b;
    end
    if ~isempty(beq)
    deq4 = Aeq*x4-beq;
    end
    if ~isempty(noncon)
    [c4,ceq4] = noncon(x4);
    end
    fval4 = objfunc(x4);        
    nfe4 = nfe;    
    
    
    results = [x1',fval1;x2',fval2;x3',fval3;x4',fval4];    
    Nfe(N,:) = [nfe1,nfe2,nfe3,nfe4];
    FVAL(N,:) = [fval1,fval2,fval3,fval4];
    X1(N,:) = x1';
    X2(N,:) = x2';
    X3(N,:) = x3';
    X4(N,:) = x4';
    D(N,:) = [d1,d2,d3,d4];
    Deq(N,:) = [deq1,deq2,deq3,deq4];
    C(N,:) = [c1,c2,c3,c4];
    Ceq(N,:) = [ceq1,ceq2,ceq3,ceq4];

end
save optimdata Nfe FVAL X1 X2 X3 D Deq C Ceq