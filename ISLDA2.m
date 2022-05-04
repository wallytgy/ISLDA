function FinalAnswer=ISLDA2(name,lst)


%Welcome to ISLDA! This is a function that takes in a string containing the
%file name and returns a cell containing 8 objects, namely:



%AlltheLengths: Array containing all the detected crystal lengths

%RedLengths: Array containing all the lengths in red boxes, which is
%probably a single crystal detection 

%Montaging: A cell containing all black-and-white images of crystals found
%in aggregates, together with the inverseradon of an image containing only
%pixels identified as local maxima

%coverage: ratio of White pixels to entire image

%blue/(blue+red): ratio of blue boxes to all boxes

%blue: number of blue boxes

%red: number of red boxes

%rn: total number of crystals detected



%There are several default parameters we have set, which include:

%lambda: Ostu's method thrhoslding parameter

%S: opening parameter for bwareaopen

%f: Threshold value for connected regions to be detected as a Type
%Red or Type Blue Box

%F: Parameter to determine whether a detected object is shaped like an
%Ellipse

%ph: Filtering parameter for the Radon Transform

%Z: parameter to specify how strong a peak should be in order to be
%considered a peak

%You may specify these parameter by calling the function together with an
%array lst that specifies the parameters in the following manner
% lst=  [lambda, S, f, F, ph, Z]

% Some suggested values for the parameters are provided in the
% ParameterTable jpeg file.

%However, should you decide to use a default parameter setting, here it is 
if nargin == 1
    lambda = 0.5;
    S= 50;
    f= 0.0001;
    F=0.7;
    phi = 0.3;
    Z= 70;
elseif nargin ==2
    lambda = lst(1);
    S= lst(2);
    f= lst(3);
    F= lst(4);
    phi = lst(5);
    Z= lst(6);
end 

%Convert RGB-image to binary
fprintf(['Now reading ' name '\n'])
I=rgb2gray(imread(name));
[rows,columns]=size(I);

%Filtering by modified Ostu's method
T=graythresh(I);
BW = imbinarize(I,lambda*T);

%Opening step
bw=bwareaopen(BW,S);

%get the bounding boxes
alltheboxes = table2array(regionprops('table',bw,'BoundingBox'));
[rows, columns] = size(alltheboxes);
limit = max(alltheboxes(:,3).* alltheboxes(:,4));
boxes=[];
boxarray=[];
%filter the bounding boxes and remove tiny ones
for i=1:rows
    if alltheboxes(i,3)*alltheboxes(i,4) >f*limit
        boxes=[boxes;alltheboxes(i,:)];
        boxarray=[boxarray,i];
    end
end 


[rbw cbw]=size(bw);

%show the image 

%calculate coverage
coverage=sum(sum(bw))/(rbw*cbw);

%obtain the number of boxes
[r c]=size(boxes);

%measure the extent and the major and minor axis length of the approximated elipses
G1= table2array(regionprops('table',bw,'Extent'));
G= G1(boxarray,:);
LEN1= table2array(regionprops('table',bw,'MajorAxisLength','MinorAxisLength'));
LEN= LEN1(boxarray,:);


%Calculate Eccentricity
Eccentricity = LEN(:,1)./LEN(:,2) ;

% Split the detected bounding boxes into red boxes and blue boxes%
LengthData=[];
bwFurtherProcessing={};
red=0;
blue=0;
for i= 1:r
    if  G(i)*boxes(i,3)*boxes(i,4)/(3.1415/4*LEN(i,1)*LEN(i,2))>F
    rectangle('position',boxes(i,:),'LineWidth',1,'LineStyle','-','Edgecolor','r');
    LengthData=[LengthData;LEN(i,:)];
    red=red+1;
    else
        rectangle('position',boxes(i,:),'LineWidth',1,'LineStyle','-','Edgecolor','b');
%keeplargestcomponent removes excess data from other crystals that are not
%supposed to be there.
        M2=keeplargestcomponent(imcrop(bw,boxes(i,:)));
        bwFurtherProcessing=[bwFurtherProcessing,M2];
        blue=blue+1;     
    end
end

%radon transform for blue boxed bad data%
[r2, c2]=size(bwFurtherProcessing);
bwRadons=cell(1,c2);
ProcessedRadons=cell(1,c2);
RadiusData={};
Montaging=cell(1,2*c2);
RadonMontage=cell(1,c2);

% also used ignorenoisepeaks to get rid of noise %
for i = 1:c2
    [m1,m2]=radon(bwFurtherProcessing{i},[0:179]);
    bwTheRadon=m1;
    bwRadons{i}=bwTheRadon;
    Detection=detectlocal2Dmaximabetter(ignorenoisepeaks(m1,phi),Z);
    InverseRadon= 100*iradon(Detection,[0:179]);
    ProcessedRadons{i}=Detection;
    Montaging{1,2*i-1}=bwFurtherProcessing{i};
    Montaging{1,2*i} = InverseRadon;
end 

[r3 c3]= size(ProcessedRadons);
Length2=[];

%Compile the detections from the radon transforms into actual lengths%
for i=1:c3
    M=ProcessedRadons{i};
    [r4 c4]= size(M);
    for j=1:r4
        for k=1:c4
            if M(j,k) ~=0
                R = bwRadons{i};
                Length2=[Length2;R(j,k)];
            end 
        end
    end
end 

%merge both lengths together
AlltheLengths=[LengthData(:,1);unique(Length2)];
GoodLengths=LengthData(:,1);
[rn cn]=size(AlltheLengths);

%final result
FinalAnswer=[{AlltheLengths},{GoodLengths},{Montaging},{coverage},{blue/(blue+red)},{blue},{red},rn];
fprintf([name ' completed! \n'])