function [Y] =ignorenoisepeaks(X,f)
M =max(X(:));
[r c]=size(X);
Y=zeros(r,c);
for i= 1:r
    for j=1:c
        if X(i,j)>f*M
            Y(i,j)=X(i,j);
        end 
    end 
end 