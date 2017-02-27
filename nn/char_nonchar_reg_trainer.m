
%% Initialization
clear ; close all; clc

input_layer_size  = 784;  % 28x28 Input Images of Digits
hidden_layer_size = 25;   % 25 hidden units
num_labels = 2;          % 10 labels, from 1 to 10   
                          % (note that we have mapped "0" to label 10)

%% =========== Part 1: Loading and Visualizing Data =============

% Load Training Data
fprintf('Loading and Visualizing Data ...\n')

X_train = loadMNISTImages('train-images.idx3-ubyte');
X_train = X_train';
X_train = logical(X_train);
load('bin_nc.mat');
load('all_black.mat');
load('all_white.mat');
X_train = [X_train; bin_nc; all_black; all_white];
y_train = [ones(60000,1); ones(60000,1)*2; ones(30000,1)*2; ones(10000,1)*2];
m = size(X_train, 1);

T = [y_train X_train];
T = T(randperm(size(T,1)),:);
X_train = T(:,2:end);
y_train = T(:,1);

%load Testing data
X_test = loadMNISTImages('t10k-images.idx3-ubyte');
X_test = X_test.';
X_test = logical(X_test);
load('bin_non_char_test.mat');
X_test = [X_test; bin_non_char_test];
y_test = [ones(10000,1); ones(5000,1)*2];

T = [y_test X_test];
T = T(randperm(size(T,1)),:);
X_test = T(:,2:end);
y_test = T(:,1);

% Randomly select 100 data points from training data set to display
%sel = randperm(size(X_train, 1));
%sel = sel(1:100);

displayData(X_train(1:100, :));

fprintf('Program paused. Press enter to continue.\n');
pause;


%% ================ Part 2: Initializing weights ================

fprintf('\nInitializing weight randomly ...\n')

Theta1_cnc = randInitializeWeights(input_layer_size, hidden_layer_size);
Theta2_cnc = randInitializeWeights(hidden_layer_size, num_labels);

% Merge parameters 
initial_nn_params = [Theta1_cnc(:) ; Theta2_cnc(:)];
org_initial_nn_params = initial_nn_params;

%% ================ Part 3: Sigmoid Gradient  ================

fprintf('\nEvaluating sigmoid gradient...\n')

g = sigmoidGradient([1 -0.5 0 0.5 1]);
fprintf('Sigmoid gradient evaluated at different learing rates[1 -0.5 0 0.5 1]:\n  ');
fprintf('%f ', g);
fprintf('\n\n');

fprintf('Program paused. Press enter to continue.\n');
pause;


%% =============== Part 4: Implement Backpropagation ===============

fprintf('\nChecking Backpropagation... \n');

%  Check gradients by running checkNNGradients
checkNNGradients;

fprintf('\nProgram paused. Press enter to continue.\n');
pause;


%% =============== Part 5: Implement Regularization ===============

fprintf('\nChecking Backpropagation (w/ Regularization) ... \n')

%  Check gradients by running checkNNGradients
lambda = 3;
checkNNGradients(lambda);

fprintf('Program paused. Press enter to continue.\n');
pause;

%% =================== Part 6: Training NN ===================

fprintf('\nTraining Neural Network... \n')

options = optimset('MaxIter', 20);

%  Try different values of lambda
lambda = 3;

% Create "short hand" for the cost function to be minimized
costFunction = @(p) nnCostFunction(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, X_train, y_train, lambda);

% Now, costFunction is a function that takes in only one argument (the
% neural network parameters)
[nn_params, cost] = fmincg(costFunction, initial_nn_params, options);

% Obtain Theta1 and Theta2 back from nn_params
Theta1_cnc = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2_cnc = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

fprintf('Program paused. Press enter to continue.\n');
pause;


%% ================= Part 7: Visualize Weights =================

fprintf('\nVisualizing Neural Network... \n')

displayData(Theta1_cnc(:, 2:end));

fprintf('\nProgram paused. Press enter to continue.\n');
pause;

%% ================= Part 8: Implement Predict =================
%  After training the neural network, we would like to use it to predict
%  the labels. You will now implement the "predict" function to use the
%  neural network to predict the labels of the training set. This lets
%  you compute the training set accuracy.

pred = predict(Theta1_cnc, Theta2_cnc, X_test);

fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == y_test)) * 100);

save Theta1_cnc.mat Theta1_cnc;
save Theta2_cnc.mat Theta2_cnc;