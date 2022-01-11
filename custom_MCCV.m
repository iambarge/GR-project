% Copyright (c) 2019, Nicolò Bargellesi
%
% This source code is licensed under the MIT-style license found in the
% LICENSE file in the root directory of this source tree.
%

function [Confusion, Correctness, order, Mdl_best] = custom_MCCV(data_points,group_labels,classes,Rate,N)
%CUSTOM_MCCV	Compute Monte Carlo CV for dataset elements and returns scores and the best model.
%   [CONFUSION,ORDER]=CUSTOM_MCCV(DATASET,TYPE,CLASSES,RATE,N) given a
%   DATA_POINTS: training matrix (X)
%   LABELS: group labels vector
%   CLASSES: cell array containing the label of the selected classes
%   RATE: validation rate percentage (as a number between 0 and 1)
%   N: number of simulations

%% Config
Confusion = zeros(length(classes));
Correctness = [];
best_score = 0;
modes = {'orario'; 'antiorario'; 'piccolo'; 'medio'; 'grande'; 'lento'; 
         'velmedia'; 'rapido'; 'verticale'; 'orizzontale'; 'obliquo'};

%% Monte Carlo Splitting
for n=1:N
train_set = [];
validation_set = [];
test_ind = 0;

for i=1:size(classes)
    for j=1:size(modes)
        add_train = find(strcmp(group_labels, strcat(classes(i),'_',modes(j))));
        for k=1:round(length(add_train)*Rate)
            add_test = datasample(add_train,1);
            test_ind = test_ind + 1;
            validation_set = [validation_set; add_test];
            add_train(find(add_train == add_test)) = [];
        end
        train_set = [train_set; add_train];
    end
end

validation_labels = group_labels(validation_set); 
validation_set = data_points(validation_set,:); 
train_labels = group_labels(train_set); 
train_set = data_points(train_set,:);


%% Rename Groups in Classes
for i=1:length(train_labels)
    if contains(train_labels(i), 'cerchio')
        train_labels(i) = {'cerchio'};
    elseif contains(train_labels(i), 'otto')
        train_labels(i) = {'otto'};
    elseif contains(train_labels(i), 'quadrato')
        train_labels(i) = {'quadrato'};
    elseif contains(train_labels(i), 'triangolo')
        train_labels(i) = {'triangolo'};
    elseif contains(train_labels(i), 'M')
        train_labels(i) = {'M'};
    elseif contains(train_labels(i), 'S')
        train_labels(i) = {'S'};
    elseif contains(train_labels(i), 'U')
        train_labels(i) = {'U'};
    elseif contains(train_labels(i), 'V')
        train_labels(i) = {'V'};
    elseif contains(train_labels(i), 'verticale_')
        train_labels(i) = {'verticale'};
    elseif contains(train_labels(i), 'orizzontale_')
        train_labels(i) = {'orizzontale'};
    end
end
for i=1:length(validation_labels)
    if contains(validation_labels(i), 'cerchio')
        validation_labels(i) = {'cerchio'};
    elseif contains(validation_labels(i), 'otto')
        validation_labels(i) = {'otto'};
    elseif contains(validation_labels(i), 'quadrato')
        validation_labels(i) = {'quadrato'};
    elseif contains(validation_labels(i), 'triangolo')
        validation_labels(i) = {'triangolo'};
    elseif contains(validation_labels(i), 'M')
        validation_labels(i) = {'M'};
    elseif contains(validation_labels(i), 'S')
        validation_labels(i) = {'S'};
    elseif contains(validation_labels(i), 'U')
        validation_labels(i) = {'U'};
    elseif contains(validation_labels(i), 'V')
        validation_labels(i) = {'V'};
    elseif contains(validation_labels(i), 'verticale_')
        validation_labels(i) = {'verticale'};
    elseif contains(validation_labels(i), 'orizzontale_')
        validation_labels(i) = {'orizzontale'};
    end
end


%% Build Tree
Mdl = TreeBagger(20,train_set,train_labels,'OOBPrediction','On',...
    'Method','classification');

%% Predict from training_set
[pred_labels] = predict(Mdl,validation_set);

%% Check for Correctness
[C,order] = confusionmat(validation_labels, pred_labels,'Order',classes);
tot=0;
right=0;
for i=1:length(classes)
    for j=1:length(classes)
        tot = tot + C(i,j);
    end
    right = right + C(i,i);
end
Corr = right/tot;
if Corr > best_score
    best_score = Corr;
    Mdl_best = Mdl;
end
Confusion = Confusion + C;
Correctness = [Correctness ; Corr];
end
Confusion = round(Confusion/N); %evaluate the mean between simulations
end

