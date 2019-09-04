function [x,fval,output]=test_CEC0819(inputnVar,CostFunction,lbT,ubT,nonlconT,eq_con_flag)
%%
%不用局部搜索的版本
%objective为适应值函数
%inputnVar为设计变量个数
%x为最佳设计变量
%fval为最佳适应值

%% DE Parameters

MaxIt     = 100000000;      % Maximum Number of Iterations
nPop      = 50;        % Population Size
pCR       = 0.65;        % Crossover Probability     
Tol       = 1e-9;
IniPop    = [];

%%  Model parameter
%约束条件的设置  LB≤x≤UB，Ax≤b，g(x)≤0 
%判断是否存在上下限，当Minflag和Maxflag为1，代表不存在
global non nfe 
lbT = lbT(:);
ubT = ubT(:); 
non = nonlconT;
Minflag = 0;
Maxflag = 0;
if  ~isempty(lbT)                % 若为真，存在下限
     varinitmin = lbT(:);       % 初始化种群时，变量可取的最小值
else
     Minflag = 1;
     varinitmin = zeros(inputnVar,1); 
end
if  ~isempty(ubT)                % 若为真，存在上限
     varinitmax = ubT(:);       % 初始化种群时，变量可取的最小值
else
     Maxflag = 1;
     varinitmax = 10*ones(inputnVar,1);
end

%%  Initial

empty_individual.Position=[];
empty_individual.Cost=[];
empty_individual.D=[];

pop=repmat(empty_individual,nPop,1);              %定义初始种群
BESTCOST=zeros(MaxIt,1);                          %储存每次迭代的最佳值
BESTmax=zeros(MaxIt,1);
initi_x_vol = zeros(nPop,1);
alf = 1e10;
  
if(~isempty(IniPop))
    pop = IniPop;
else
    X = lhsdesign(inputnVar,nPop);%拉丁超立方采样    
    for i=1:nPop  
        
        pop(i).Position = varinitmin+(varinitmax-varinitmin).*X(:,i);   
        [c0,ceq0] = nonlconT(pop(i).Position);
        c = max(0,c0);
        ceq = abs(ceq0);
        D = [c;ceq];
        initi_x_vol(i) = max(D);
        pop(i).D = max(D);
        sig = eye(length(c)+length(ceq))*alf;
        pop(i).Cost = CostFunction(pop(i).Position)+D'*sig*D;
    end
end

BestSol = pop(1);
for  ki=2:nPop
      if  pop(ki).Cost<BestSol.Cost
          BestSol=pop(ki);
      end
end    
    
cross = 0;
star_index = 0;
LP = 2;
Suc_Mem = zeros(LP,4);
Fai_Mem = zeros(LP,4);
CR_Mem = zeros(LP,8);

%%  Optimization
for it=1:MaxIt                                           %循环MaxIt次   
     
    if rem(it,LP)            
       k_index = rem(it,LP);
       Suc_Mem(k_index,:) = 0;
       Fai_Mem(k_index,:) = 0;
    else
       k_index = LP;
       Suc_Mem(k_index,:) = 0;
       Fai_Mem(k_index,:) = 0;
    end        
    
    [~,init_sta_type_arry] = dec_sta_type(1/4,1/4,1/4,1/4,1,nPop);
    
    %deci_CR
     if it<=LP
        CR_Mem(it,1) = normrnd(0.5,0.1);
        CR_Mem(it,3) = normrnd(0.5,0.1);
        CR_Mem(it,5) = normrnd(0.5,0.1);
        CR_Mem(it,7) = normrnd(0.5,0.1);     
     else
        [CRM1,CRM2,CRM3,CRM4] = cal_CRM(CR_Mem);
        CR_Mem(k_index,1) = normrnd(CRM1,0.1);
        CR_Mem(k_index,3) = normrnd(CRM2,0.1);
        CR_Mem(k_index,5) = normrnd(CRM3,0.1);
        CR_Mem(k_index,7) = normrnd(CRM4,0.1); 
        CR_Mem(k_index,2) = 0;
        CR_Mem(k_index,4) = 0;
        CR_Mem(k_index,6) = 0;
        CR_Mem(k_index,8) = 0;         
    
     end
        
    %%  进行差分进化循环
    for i=1:nPop                                         %对nPop个个体进行差分
        
        F = normrnd(0.5,0.3,1,inputnVar);
        K = 0.5;
              
        %deci_muta_type
        if it<=LP
            sta_type = init_sta_type_arry(i);
        else
            sta_type = dec_sta_type(P1,P2,P3,P4,2,nPop);
        end        
                            
        x=pop(i).Position;
        
        % Mutation
        %挑选四个不同的数字，保证选择到四个不同的行
        %只要前面三个数有一个等于i，就去掉该位置，这样就保证了四个数均不相同
        D=randperm(nPop);
        D(D==i)=[];
        a1=D(1);
        b1=D(2);
        c1=D(3);  
        d1=D(4);
        e1=D(5);
%         id = wheel(initi_x_fval,5);
%         a1 = id(1);
%         b1 = id(2);
%         c1 = id(3);        
%         d1 = id(4);
%         e1 = id(5);         
        F = F(:);
        switch sta_type
            case 1
                y=pop(i).Position+F.*(pop(a1).Position-pop(b1).Position);
                muta_pop = pop(i).Position;
                star_index = 1;
                pCR = CR_Mem(k_index,1);
            case 2
                y=pop(i).Position+F.*(BestSol.Position-pop(i).Position+pop(a1).Position-pop(b1).Position+pop(c1).Position-pop(d1).Position);
                muta_pop = pop(i).Position;
                star_index = 2;
                pCR = CR_Mem(k_index,3);
            case 3
                y=pop(a1).Position+F.*(pop(b1).Position-pop(c1).Position+pop(d1).Position-pop(e1).Position);
                muta_pop = pop(a1).Position;
                star_index = 3;
                pCR = CR_Mem(k_index,5);
            case 4
%                 y=pop(i).Position+K.*(pop(a1).Position-pop(i).Position)+F.*(pop(c1).Position-pop(d1).Position);
%                 star_index = 4;
%                 cross = 1;
                mutFF=normrnd(0.5,0.3);
                y=BestSol.Position+K.*(pop(a1).Position-pop(i).Position)+mutFF*(pop(c1).Position-pop(d1).Position);
                muta_pop = BestSol.Position;
                star_index = 4;
                cross = 1;
        end
                
        if ~Minflag                                       % 若为真，则存在下限
            y = max(y, lbT);
        end
        if ~Maxflag                                   % 若为真，则存在上限
		    y = min(y, ubT);                               %y为变异个体
        end
                
        % Crossover
        switch cross
            case 0
                z=zeros(size(x));        
                j0=randi([1 numel(x)]); %randi（iMax）在开区间（0，iMax）生成均匀分布的伪随机整数  %numel返回数组中元素个数
                for j=1:numel(x)
                    if j==j0 || rand<=pCR
                        z(j)=y(j);
                    else
                        z(j)=x(j);
                    end                    
                end 
            case 1
                z = y;
                cross = 0;
        end

        %产生试验个体        
        [c0,ceq0] = nonlconT(z);
        c = max(0,c0);
        ceq = abs(ceq0);
        D = [c;ceq];   
        if   max(D)>0            
            options = optimoptions('fmincon','Display','off','Algorithm','sqp');
            if  eq_con_flag==1
                try
                   z = fmincon(@(x)objfunc0(x,z),z,[],[],[],[],lbT,ubT,nonlconT,options);
                catch ErrorInfo
                    1;
                end
            else
                x_array = [muta_pop z];
                newnon = @(x)non2(x,x_array);
                initial = z+0.01*ones(inputnVar,1);
                try
                    z = fmincon(@(x)objfunc0(x,z),initial,[],[],[],[],lbT,ubT,newnon,options);   
                catch ErrorInfo
                    2;
                end
            end
        end 
%=======================Select================================            
        [c0,ceq0] = nonlconT(z);
        c = max(0,c0);
        ceq = abs(ceq0);
        D = [c;ceq];                                  
        sig = eye(length(c)+length(ceq))*alf;         
        fval = CostFunction(z)+D'*sig*D;
        if  pop(i).Cost>=fval   
            switch star_index 
                case 1
                    Suc_Mem(k_index,1) = Suc_Mem(k_index,1)+1;
                    CR_Mem(k_index,2) = CR_Mem(k_index,2)+1;
                case 2
                    Suc_Mem(k_index,2) = Suc_Mem(k_index,2)+1;
                    CR_Mem(k_index,4) = CR_Mem(k_index,4)+1;
                case 3
                    Suc_Mem(k_index,3) = Suc_Mem(k_index,3)+1;
                    CR_Mem(k_index,6) = CR_Mem(k_index,6)+1;
                case 4
                    Suc_Mem(k_index,4) = Suc_Mem(k_index,4)+1;
            end
            pop(i).Cost = fval;          
            pop(i).Position = z;
            pop(i).D = max(D);           
        else
            switch star_index
                case 1
                    Fai_Mem(k_index,1) = Fai_Mem(k_index,1)+1;
                case 2
                    Fai_Mem(k_index,2) = Fai_Mem(k_index,2)+1;
                case 3
                    Fai_Mem(k_index,3) = Fai_Mem(k_index,3)+1;
                case 4
                    Fai_Mem(k_index,4) = Fai_Mem(k_index,4)+1;
            end
        end           

    end  
    
                 
    %%  寻找该次迭代中最佳个体
%     disp([' It.: ' sprintf('%4i',it)      'ok']);
    for  ki=1:nPop
          if  pop(ki).Cost<BestSol.Cost
              BestSol=pop(ki);
          end
    end
     
    BESTCOST(it) = BestSol.Cost; 
    z = BestSol.Position;

    [c0,ceq0] = nonlconT(z);
    c = max(0,c0);
    ceq = abs(ceq0);
     
    max_c = max(c);
    max_ceq = max(ceq);
    BESTmax (it) = max([max_c,max_ceq]);
      
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BESTCOST(it)) ' STD = ' num2str(BESTmax (it))]);             
    %%  fuzzy自适应beta
     if  k_index >= LP
%          [P1,P2,P3,P4] = cal_STA_pro(Suc_Mem,Fai_Mem);
         [P1,P2,P3,P4] = cal_STA_pro_0318(Suc_Mem,Fai_Mem,k_index,LP);
     end           
    
    if it == 50
        disp([' LP.: ' sprintf('%4i',it)      'ok']);
    end
    
    %% 终止条件    
    if  nfe>=600000
        break;
    end  

end

%%
%输出最终结果
x = BestSol.Position;
fval = CostFunction(x);
output.BestCost = BESTCOST(1:it);
output.nIter = it;

end

%% ===================寻找最近点目标函数======================
function [y,g] = objfunc0(x,x0)
dx = x-x0;
y = 1/2*(dx'*dx);
g = dx;
end

function [c,ceq] = non2(x,x_array)
global non
if isempty(non)            
    c = [];
    ceq = [];
else
    [c0,ceq0] = non(x);
    c = max(0,c0);
    ceq = abs(ceq0);
end
% ceq_com = abs(dot(x-x_array(2,:),x_array(1,:)-x_array(2,:))/(norm(x-x_array(2,:))*norm(x_array(1,:)-x_array(2,:))));
ceq_com = abs(dot(x-x_array(:,2),x_array(:,1)-x_array(:,2))/(norm(x-x_array(:,2))*norm(x_array(:,1)-x_array(:,2))));
ceq = [ceq;ceq_com];
end