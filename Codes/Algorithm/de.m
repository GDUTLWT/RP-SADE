%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA107
% Project Title: Implementation of Differential Evolution (DE) in MATLAB
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%
function [optVar,optFval,output] = de(nVar,CostFunction,AA,bb,AAeq,bbeq,lb,ub,noncon,options)

global dmodel

%% DE Parameters
if nargin<10
    MaxIt=1000;      % Maximum Number of Iterations
    nPop=50;        % Population Size
    beta_min=0.2;   % Lower Bound of Scaling Factor
    beta_max=0.8;   % Upper Bound of Scaling Factor
    pCR=0.2;        % Crossover Probability
    pMu = 0.2;      
    Tol=1e-9;
    IniPop = [];
    surrogate = 0;
else
    MaxIt=options.MaxIt;      % Maximum Number of Iterations
    nPop=options.nPop;        % Population Size
    beta_min=options.beta_min;   % Lower Bound of Scaling Factor
    beta_max=options.beta_max;   % Upper Bound of Scaling Factor
    pCR=options.pCR;        % Crossover Probability
    pMu = options.pMu;
    Tol=options.Tol;
    IniPop = options.IniPop;
    surrogate = options.surrogate;
end
%% Initialization

empty_individual.Position=[];
empty_individual.Cost=[];

BestSol.Cost=inf;

pop=repmat(empty_individual,nPop,1);
popnew=repmat(empty_individual,nPop,1);

funcval = zeros(nPop,1);
pfun = zeros(nPop,1);
funnew = zeros(nPop,1);
%% =====================初始种群====================

if(~isempty(IniPop))
    pop = IniPop;
else
    X = lhsdesign(nPop,nVar);%拉丁超立方采样    
    for i=1:nPop
%         pop(i).Position=unifrnd(lb,ub);   
        pop(i).Position = lb+(ub-lb).*X(i,:)';
        pop(i).Cost=CostFunction(pop(i).Position); 
    end
end

for i=1:nPop
    funcval(i) = pop(i).Cost;
end

BestCost=zeros(MaxIt,1);
BESTmax = zeros(MaxIt,1);

%% ================初始近似模型=====================

theta = 10*ones(nVar,1);
lob = 1*ones(nVar,1);
upb = 20*ones(nVar,1);
S = zeros(nPop,nVar);
Y = zeros(nPop,1);
PY = zeros(nPop,1);
alf = 1e10;
for i=1:nPop
    x = pop(i).Position;
    S(i,:) = pop(i).Position;    
    Y(i,1) = pop(i).Cost; 
        if isempty(bb)
            d = [];
        else
            d = max(0,AA*x-bb);
        end
        if isempty(bbeq)
            deq = [];
        else
            deq = abs(AAeq*x-bbeq);
        end
        if isempty(noncon)            
            c = [];
            ceq = [];
        else
            [c0,ceq0] = noncon(x);
            c = max(0,c0);
            ceq = abs(ceq0);
        end
        sig = eye(length(d)+length(deq)+length(c)+length(ceq))*alf;
        D = [d;deq;c;ceq];        
        PY(i) = Y(i)+D'*sig*D;
        
end
dmodel = dacefit(S,Y,@regpoly0,@corrgauss,theta,lob,upb);


%% =================优化主流程=================================
Nss = 0;%相似解次数
for it=1:MaxIt     
 %% ===================局部寻优========================   
    for i = 1:nPop        
        x0 = pop(i).Position;
        [c,ceq] = noncon(x0);
        d = AA*x0-bb;
        deq = AAeq*x0-bbeq;
        v = [max(c,0);abs(ceq);max(d,0);abs(deq)];
        options = optimoptions('fmincon','Display','off','Algorithm','sqp');
        if(max(v)>Tol)
         %=============================不满足约束时，寻找满足约束的且与当前点最近的点==========================            
            [x,fval,flag,output1] = fmincon(@(x)objfunc0(x,x0),x0,AA,bb,AAeq,bbeq,lb,ub,noncon,options);
        else 
         %=============================满足约束时，缩小边界进行局部寻优===================================
            dx = (ub-lb)*0.05;            
            lb0 = max(x0-dx,lb);
            ub0 = min(x0+dx,ub);
            if(surrogate==0)
            [x,fval,flag,output1] = fmincon(CostFunction,x0,AA,bb,AAeq,bbeq,lb0,ub0,noncon,options);
            elseif(surrogate==1)
            [x,fval,flag,output1] = fmincon(@modelfunc,x0,AA,bb,AAeq,bbeq,lb0,ub0,noncon,options);
            end
        end
       
        
        %===============验证约束====================
        if isempty(bb)
            d = [];
        else
            d = max(0,AA*x-bb);
        end
        if isempty(bbeq)
            deq = [];
        else
            deq = abs(AAeq*x-bbeq);
        end
        if isempty(noncon)            
            c = [];
            ceq = [];
        else
            [c0,ceq0] = noncon(x);
            c = max(0,c0);
            ceq = abs(ceq0);
        end
        sig = eye(length(d)+length(deq)+length(c)+length(ceq))*alf;
        D = [d;deq;c;ceq];
   
        %===================构造罚函数========================
        if surrogate==0
            fval = CostFunction(x);
        elseif surrogate==1
            [py,g,mse] = predictor(x,dmodel);
            if(mse<1e-9)
                fval = py;
            else
                fval = CostFunction(x);
            end
        end
        popnew(i).Position = x;
        popnew(i).Cost = fval+D'*sig*D;
        funnew(i) = fval;
        
        pfun(i) = popnew(i).Cost;
        
         if popnew(i).Cost<BestSol.Cost
              BestSol=popnew(i);
         end         
    end

    
    BestCost(it)=BestSol.Cost;
    bestpop = BestSol.Position;
        if isempty(bb)
            d = [];
        else
            d = max(0,AA*bestpop-bb);
        end
        if isempty(bbeq)
            deq = [];
        else
            deq = abs(AAeq*bestpop-bbeq);
        end
        if isempty(noncon)            
            c = [];
            ceq = [];
        else
            [c0,ceq0] = noncon(bestpop);
            c = max(0,c0);
            ceq = abs(ceq0);
        end      
        max_d = max(d);
        max_deq = max(deq);
        max_c = max(c);
        max_ceq = max(ceq);
        BESTmax (it) = max([max_d,max_deq,max_c,max_ceq]);
       disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it)) ' STD = ' num2str(BESTmax (it))]);     
      
    err = std(pfun);
                % Show Iteration Information    
%     disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it)) ' STD = ' num2str(err)]);
    
    if(it>1)
        df = abs(BestCost(it)-BestCost(it-1))/abs(BestCost(it));
        if(df<1e-9)
            Nss = Nss+1;
        else
            Nss = 0;
        end
    end

    %=================终止条件一：连续五步相似解;终止条件二：种群中全部个体相似==================== 
    if(Nss==5||err<Tol)
        optVar = BestSol.Position;
        optFval = BestSol.Cost;
        output.BestCost = BestCost(1:it);
        output.nIter = it;
        output.Err = err;
        break;
    end
    
%% =====================更新近似模型=========================    
    Sn = zeros(nPop,nVar);
    Yn = zeros(nPop,1);
    PYn = zeros(nPop,1);
     for i = 1:nPop
         Sn(i,:) = popnew(i).Position;
         Yn(i) = funnew(i);
         PYn(i) = popnew(i).Cost;
     end
     S = [S;Sn];
     Y = [Y;Yn];
     PY = [PY;PYn];
 %=================清除重复样本=======================
     ns = length(Y);
     mk = zeros(ns,1);
     for i = 1:ns-1
         for j = i+1:ns
             if(mk(i)==0)
                 si = S(i,:);
                 sj = S(j,:);
                 yi = Y(i);
                 yj = Y(j);
                 pyi = PY(i);
                 pyj = PY(j);
                 ds = si-sj;
                 if(norm(ds)<1e-6)
                     if(PY(i)<PY(j))
                         mk(j) = 1;
                     else
                         mk(i) = 1;
                         continue;
                     end
                 end
             end
         end
     end
     S(mk==1,:) = [];
     Y(mk==1) = [];
     PY(mk==1) = [];

     ns = length(Y);
     mns = 200;
     if(ns>mns)
         [PY1,ii] = sort(PY);
         S1 = S(ii,:);
         Y1 = Y(ii);
         S = S1(1:mns,:);
         Y = Y1(1:mns);
         PY = PY1(1:mns);
     end
     
   %==================更新近似模型============================  
    dmodel = dacefit(S,Y,@regpoly0,@corrgauss,theta,lob,upb);
    
  %% ====================DE主流程===========================  
    for i=1:nPop   
 %===================================================        
        x = popnew(i).Position;  
        
%         A=randperm(nPop);        
%         A(A==i)=[];        
%         a=A(1);
%         b=A(2);
%         c=A(3);        
        
        id = wheel(pfun,3);
        a = id(1);
        b = id(2);
        c = id(3);
        
%===================Mutation====================
%         beta=unifrnd(beta_min,beta_max);
        if rand<=pMu
            beta=unifrnd(beta_min,beta_max,nVar,1);
            y=popnew(a).Position+beta.*(popnew(b).Position-popnew(c).Position);
%             y = BestSol.Position+beta.*(popnew(a).Position-popnew(b).Position);
        else
%             y = popnew(a).Position;
            y = BestSol.Position;
        end
        y = max(y, lb);
		y = min(y, ub);		
%===================Crossover========================
        z=zeros(size(x));
        j0=randi([1 numel(x)]);
        for j=1:numel(x)
            if j==j0 || rand<=pCR
                z(j)=y(j);
            else
                z(j)=x(j);
            end
        end        
        NewSol.Position=z;
        NewSol.Cost=0;
        pop(i)=NewSol;                   
    end
    
end

optVar = BestSol.Position;
optFval = BestSol.Cost;
output.BestCost = BestCost(1:it);
output.nIter = it;
output.Err = err;

%% Show Results

figure;
plot(BestCost(1:it));
% semilogy(BestCost, 'LineWidth', 2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;



%% ===================寻找最近点目标函数======================
function [y,g] = objfunc0(x,x0)
dx = x-x0;
y = 1/2*(dx'*dx);
g = dx;





