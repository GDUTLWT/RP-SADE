function id = wheel(a,n)
m = length(a);
a0 = (max(a)-a)/(max(a)-min(a));
a1 = a0.^3;
a2 = a1/sum(a1);
a3 = zeros(m+1,1);
for i = 1:m
    a3(i+1) = sum(a2(1:i));
end
for i = 1:n
    b = rand(1);
    for j = 1:m
        if b>a3(j)&&b<=a3(j+1)
            id(i) = j;
        end
    end
end



