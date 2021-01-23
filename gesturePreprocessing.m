function [data_points,labels] = gesturePreprocessing(dataset,Type)
%GESTUREPREPROCESSING Applies different preprocessing/feature extraction
%techniques according to the type and returns train and label matrices
%   DATASET: table containing the dataset
%   TYPE: Pre-Processing type, selected by a number:
%           1 - Crop
%           2.1 - Resampling V.1
%           2.2 Resampling V.2
%           3 - Feature Based

% Extract Data Points/Features
if Type == 1
% Crop Measures
duration_min = inf; % Should become 317
for i=1:size(dataset,1)
    if (size(dataset.PolDX_X{i,1},1) < duration_min)
        duration_min = size(dataset.PolDX_X{i,1},1);
    end
end

for i=1:size(dataset,1)
    data_points(i,1:duration_min*3) = [transpose(dataset.PolDX_X{i,1}(1:duration_min)) transpose(dataset.PolDX_Y{i,1}(1:duration_min)) transpose(dataset.PolDX_Z{i,1}(1:duration_min))];
end

elseif Type == 2.1
% Resample Measures V.1
dim_min = inf; % Should become 317
for i=1:size(dataset,1)
    if (size(dataset.PolDX_X{i,1},1) < dim_min)
        dim_min = size(dataset.PolDX_X{i,1},1);
    end
end

X = zeros(dim_min);
Y = zeros(dim_min);   % Preallocated for Speed
Z = zeros(dim_min);

for i=1:size(dataset,1)
    dim = size(dataset.PolDX_X{i,1},1);
    for j=1:dim_min
        k = round(j*dim/dim_min);
        X(j) = dataset.PolDX_X{i,1}(k);
        Y(j) = dataset.PolDX_Y{i,1}(k);
        Z(j) = dataset.PolDX_Z{i,1}(k);
    end
    data_points(i,1:dim_min*3) = [X(1:dim_min), Y(1:dim_min), Z(1:dim_min)];
end

elseif Type == 2.2
% Resample Measures V.2
new_samp = inf; % Should become 317
for i=1:size(dataset,1)
    if (size(dataset.PolDX_X{i,1},1) < new_samp)
        new_samp = size(dataset.PolDX_X{i,1},1);
    end
end

for i=1:size(dataset,1)
    samp = size(dataset.PolDX_X{i,1},1);
    X = resample(dataset.PolDX_X{i,1},new_samp,samp);
    Y = resample(dataset.PolDX_Y{i,1},new_samp,samp);
    Z = resample(dataset.PolDX_Z{i,1},new_samp,samp);
    data_points(i,1:(new_samp-20)*3) = [transpose(X(11:new_samp-10)), transpose(Y(11:new_samp-10)), transpose(Z(11:new_samp-10))];
end

elseif Type == 3
% Features Extraction
for i=1:size(dataset,1)
    Max = [max(dataset.PolDX_X{i,1}) max(dataset.PolDX_Y{i,1}) max(dataset.PolDX_Z{i,1})];
    Min = [min(dataset.PolDX_X{i,1}) min(dataset.PolDX_Y{i,1}) min(dataset.PolDX_Z{i,1})];
    Mean = [mean(dataset.PolDX_X{i,1}) mean(dataset.PolDX_Y{i,1}) mean(dataset.PolDX_Z{i,1})];
    Var = [var(dataset.PolDX_X{i,1}) var(dataset.PolDX_Y{i,1}) var(dataset.PolDX_Z{i,1})];
    Ene = [sum(abs(dataset.PolDX_X{i,1}).^2) sum(abs(dataset.PolDX_Y{i,1}).^2) sum(abs(dataset.PolDX_Z{i,1}).^2)];
    
    data_points(i,:) = [Max Min Mean Var Ene];
end  
end

% Extract Labels
labels = table2cell(dataset(:,1));
% Rename Groups in Classes
for i=1:length(labels)
    if contains(labels(i), 'cerchio')
        labels(i) = {'cerchio'};
    elseif contains(labels(i), 'otto')
        labels(i) = {'otto'};
    elseif contains(labels(i), 'quadrato')
        labels(i) = {'quadrato'};
    elseif contains(labels(i), 'triangolo')
        labels(i) = {'triangolo'};
    elseif contains(labels(i), 'M')
        labels(i) = {'M'};
    elseif contains(labels(i), 'S')
        labels(i) = {'S'};
    elseif contains(labels(i), 'U')
        labels(i) = {'U'};
    elseif contains(labels(i), 'V')
        labels(i) = {'V'};
    elseif contains(labels(i), 'verticale_')
        labels(i) = {'verticale'};
    elseif contains(labels(i), 'orizzontale_')
        labels(i) = {'orizzontale'};
    end
end

end

