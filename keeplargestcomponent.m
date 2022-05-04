function M=keeplargestcomponent(X)
CC= bwconncomp(X);
numPixels = cellfun(@numel,CC.PixelIdxList);
[~,idx] = max(numPixels);
[r,c]=size(X);
M= zeros(r,c);
M(CC.PixelIdxList{idx})=1;
end 