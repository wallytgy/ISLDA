function J=Miniphotoshop(M1,M2) 
[r c]= size(M2);
J= zeros(r,c);
for i=1:r
    for j=1:c
        if M2(i,j) ==1
            J(i,j)=M1(i,j);
        end 
    end 
end 
    
