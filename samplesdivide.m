function [DataTest DataTrain CTest CTrain indian_pines_map] = samplesdivide(indian_pines_corrected,indian_pines_gt,train,randpp);

percent = 0.20;
[m n p] = size(indian_pines_corrected);
CTrain = [];CTest = [];
DataTest  = [];
DataTrain = [];
indian_pines_map = uint8(zeros(m,n));
data_col = reshape(indian_pines_corrected,m*n,p);
[mm nn] = ind2sub([m n],1:m*n);
data_col = [double(indian_pines_gt(:)) mm' nn' data_col];
for i = 1:max(indian_pines_gt(:))
    ci = length(find(indian_pines_gt==i));
    
    [v]=find(indian_pines_gt==i);
    
    datai = data_col(find(indian_pines_gt==i),:);
    
    cTrain = round(train);
%     cTest  = round(0.1*ci); 
    cTest  = ci-cTrain;
%     cTest = round(30);
    CTrain = [CTrain cTrain];
    CTest = [CTest cTest];
%     index = randperm(ci);
    index = randpp{i};
    DataTest = [DataTest; datai(index(1:cTest),:)];
    DataTrain = [DataTrain; datai(index(cTest+1:cTest+cTrain),:)];
    indian_pines_map(v(index(1:cTest))) = i;    
end
% indian_pines_map = reshape(indian_pines_map,m,n);