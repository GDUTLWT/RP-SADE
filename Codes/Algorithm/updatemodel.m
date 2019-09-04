function updatemodel(x,y)
% 传进来的x必须为行向量
global S Y theta lob upb dmodel
% 更新代理模型
ns = 200;
uy = 0;



    

if(length(Y)>ns)
    [Y1,ii] = sort(Y);
    S1 = S(ii,:);
    S = S1(1:ns,:);
    Y = Y1(1:ns);
% elseif(length(Y)<ns)
%     S = [S;x];
%     Y = [Y;y];
end

for i = 1:length(x)
    dS(:,i) = S(:,i)-x(i);
end
mS = sqrt(sum(dS'.^2));
if(min(mS)<1e-6)
    k = find(mS<1e-6);
    S(k(1),:) = x;
    Y(k(1)) = y;
    uy = 1;
end

if(uy==0)
    if(max(Y)>y)
        S(Y==max(Y),:) = x;
        Y(Y==max(Y)) = y;
        uy = 1;
    end
end



[m,n] = size(S);
ll = 0;
for k = 1 : m-1
  ll = ll(end) + (1 : m-k);
%   ij(ll,:) = [repmat(k, m-k, 1) (k+1 : m)']; % indices for sparse matrix
  D(ll,:) = repmat(S(k,:), m-k, 1) - S(k+1:m,:); % differences between points
end
if  min(sum(abs(D),2) ) == 0
  error('Multiple design sites are not allowed')
end


if(uy==1)
dmodel = dacefit(S,Y,@regpoly0,@corrgauss,theta,lob,upb);
end