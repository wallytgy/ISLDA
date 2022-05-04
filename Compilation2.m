s=input('Enter a positive integer. How many photos per bin? \n')
fprintf('If you would like to specify a parameter list, please write a list containing 6 parameters.\nElse, type 0\n')
lst = input('Write list here:  ')
if lst == 0
picturenames=dir('*tif*');
[r,c1]=size(picturenames);
NumberofBins=ceil(r/s);
GoodCrystalFamily=cell(1,NumberofBins);
AllCrystalFamily=cell(1,NumberofBins);
CoverageFamily=cell(1,NumberofBins);
RatioFamily=cell(1,NumberofBins);
BlueFamily=cell(1,NumberofBins);
RedFamily=cell(1,NumberofBins);
for i=1:NumberofBins
    k = min(s,r-s*(i-1));
    GoodCrystalBin=cell(1,k);
    AllCrystalBin=cell(1,k);
    CoverageBin=cell(1,k);
    RatioBin=cell(1,k);
    BlueBin=cell(1,k);
    RedBin=cell(1,k);
    for j=1:k
        FinalAnswer=ISLDA2(picturenames(s*(i-1)+j).name);
        AllCrystalBin{j}=FinalAnswer{1};
        GoodCrystalBin{j}=FinalAnswer{2};
        CoverageBin{j}=FinalAnswer{4};
        RatioBin{j}=FinalAnswer{5};
        BlueBin{j}=FinalAnswer{6};
        RedBin{j}=FinalAnswer{7};
    end 
    GoodCrystalFamily{i}=GoodCrystalBin;
    AllCrystalFamily{i}=AllCrystalBin;
    CoverageFamily{i}=CoverageBin;
    RatioFamily{i}=RatioBin;
    BlueFamily{i}=BlueBin;
    RedFamily{i}=RedBin;
end 
else 
picturenames=dir('*tif*');
[r,c1]=size(picturenames);
NumberofBins=ceil(r/s);
GoodCrystalFamily=cell(1,NumberofBins);
AllCrystalFamily=cell(1,NumberofBins);
CoverageFamily=cell(1,NumberofBins);
RatioFamily=cell(1,NumberofBins);
BlueFamily=cell(1,NumberofBins);
RedFamily=cell(1,NumberofBins);
for i=1:NumberofBins
    k = min(s,r-s*(i-1));
    GoodCrystalBin=cell(1,k);
    AllCrystalBin=cell(1,k);
    CoverageBin=cell(1,k);
    RatioBin=cell(1,k);
    BlueBin=cell(1,k);
    RedBin=cell(1,k);
    for j=1:k
        FinalAnswer=ISLDA2(picturenames(s*(i-1)+j).name,lst);
        AllCrystalBin{j}=FinalAnswer{1};
        GoodCrystalBin{j}=FinalAnswer{2};
        CoverageBin{j}=FinalAnswer{4};
        RatioBin{j}=FinalAnswer{5};
        BlueBin{j}=FinalAnswer{6};
        RedBin{j}=FinalAnswer{7};
    end 
    GoodCrystalFamily{i}=GoodCrystalBin;
    AllCrystalFamily{i}=AllCrystalBin;
    CoverageFamily{i}=CoverageBin;
    RatioFamily{i}=RatioBin;
    BlueFamily{i}=BlueBin;
    RedFamily{i}=RedBin;
end 
end
    
%AllFamilies is a cell containing the results after a sequence of outputs
%from ISLDA. AllCrystalFamily is a cell containing AllCrystalBins. Each Bin
%contains data from s images, where s is the input number. The definition
%is similar for the rest of the Families. 

AllFamilies=[{AllCrystalFamily},{GoodCrystalFamily},{CoverageFamily},{RatioFamily},{BlueFamily},{RedFamily}];