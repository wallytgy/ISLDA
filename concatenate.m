function Data= concatenate(X)
[r c]= size(X)
Data=[]
for i=1:c
     Data=[Data; X{i}]
end 

