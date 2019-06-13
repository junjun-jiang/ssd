clear all; 
close all; clc

load PaviaU
load PaviaU_gt
load PaviaU_randp % for the consistency, we generate the rand index in advance

lambdaa = [1e-2]; % the best performance is obtained around 1e-2
windows = [15];   % the best performance is obtained around 15
Ctrain = [60];    % training samples per class

for iter = 1:10
    randpp=randp{iter};
    for iCtrain = 1:size(Ctrain,2)
        train = Ctrain(iCtrain);
        
        for iwindow = 1:size(windows,2)
            window = windows(iwindow);
            % randomly divide the dataset to training and test samples
            [DataTest, DataTrain, CTest, CTrain, map] = samplesdivide(paviaU,paviaU_gt,train,randpp);
            %%%%%%%% Normalize
            Normalize = max(max(DataTrain(:,4:end)));
            DataTrain(:,4:end) = DataTrain(:,4:end)./Normalize;
            DataTest(:,4:end) = DataTest(:,4:end)./Normalize;

            for ilambda = 1:size(lambdaa,2)
                disp([iter iCtrain iwindow ilambda])
                lambda = lambdaa(ilambda); % need to find the optimal
                class = SSD_Classification(DataTrain, CTrain, DataTest, lambda,window);
                [confusion, accur_NRS, TPR, FPR] = confusion_matrix_wei(class, CTest);
                accur(iter,iCtrain,iwindow, ilambda) = accur_NRS;
            end
        end
    end
end

save('ssd_accur.mat','accur')



