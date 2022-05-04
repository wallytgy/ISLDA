function Y=Histogramming(X)
[r c]=size(X)
Y={}
for i=1:c
    Y=[Y,X{i}{1}]
end 
hist3(concatenate(timetag(Y)),{0:20:360,-100:200:4000}), 
xlabel('Length in Pixels')
ylabel('Time in seconds')
title('All crystal detections against time')
