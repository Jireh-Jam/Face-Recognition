%% Choosing Rule for different image matrices. SVD-NMF for initialization of NMF algorithm
function [u ,s, v ,p] = ChoosingR(Z)
[u, s, v] = svd(Z);
sum1 = sum(s);
sum2 = sum(sum1);
extract = 0;
p = 0;
dsum = 0;
while(extract/sum2<0.90)
    p = p+1;
    dsum = dsum+s(p,p);
    extract = dsum;
end
end
