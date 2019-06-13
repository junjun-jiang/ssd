clc
clear
close all


load('F:\金山快盘\高光谱影像分类\李伟 北京化工大学\NRS_DLRC\Indian_pines_corrected.mat')
load('F:\金山快盘\高光谱影像分类\李伟 北京化工大学\NRS_DLRC\Indian_pines_gt.mat')
[m n d] = size(indian_pines_corrected);
feas = reshape(indian_pines_corrected,m*n,d);

randp = cell(1,10);

for j = 1:10
    temp = cell(1,max(indian_pines_gt(:)));
    featureMat  = [];
    label = [];
    for i=1:max(indian_pines_gt(:))
        k = find(indian_pines_gt==i);
        round(0.2*length(k))
        featureMat = [featureMat; feas(k,:)];
        label = [label double(i)*ones(1,length(k))];
        temp{1,i} = randperm(length(k));
    end
    randp{1,j}=temp;
    clear temp;
end
featureMat = featureMat';
save('Indian_pines_randp.mat','randp');
% save('PaviaU_FLR.mat','featureMat','label','randp');