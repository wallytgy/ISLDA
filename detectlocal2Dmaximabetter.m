function Y = detectlocal2Dmaximabetter(X,Z)
[r c]=size(X);
z=ceil(sqrt(r*c/Z));
J=zeros(r+2*z,c+2*z);
x1= zeros(r+2*z,c+2*z);
x1(z+1:r+z,z+1:c+z)=X;
for i=z+1:r+z
    for j=z+1:c+z
        M=x1([i-z:i+z],[j-z:j+z]);
        Maxx=max(M(:));
        if Maxx==x1(i,j)
            J(i,j)=Maxx;
        end 
    end
end
Y=J([z+1:r+z],[z+1:c+z]);
