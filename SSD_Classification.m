function class = SSD_Classification(DataTrain, CTrain, DataTest, lambda, window)

numClass = length(CTrain);
[m Nt]= size(DataTest);
for j = 1: m
    if mod(j,round(m/10))==0
        fprintf('*...');
    end
    
    %% Obtain nearest set of pixel j
    [tm] = DataTest(j, 2);
    [tn] = DataTest(j, 3);    
    [v]=find(DataTest(:,1)==DataTest(j, 1));
    DataTestc = DataTest(v, 4:end);
    [val idx]=sort(sum((DataTest(:,2:3)-repmat([tm tn],m,1)).^2,2));
    %% spatial+spectral similarity
    idx = idx(find(val<=2*(floor(window/2)).^2));    
    [val2 idx2]=sort(sum((DataTest(idx(2:end),4:end)-repmat(DataTest(j,4:end),length(idx)-1,1)).^2,2));%     
    idx = [idx(1); idx(1+idx2(find(val2<=1.1*mean(val2))))]; % c=1.1

    Yn = DataTest(idx,4:end); % nearest set of pixel j
    
    %% distance between sets based on DLRC
    a = 0;
    for i = 1: numClass 
        % Obtain Multihypothesis from training data
        HX = DataTrain((a+1): (CTrain(i)+a), 4:end);
        a = CTrain(i) + a;
        Y_dist(i) = SetDistance(HX',Yn',lambda);
    end
   [value class(j)] = min(Y_dist);
end
