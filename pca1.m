function [signals, PC, V] = pca1(data, m)
% Use covariance to run PCA
% Signals: M x N matrix of projected data
%       V: M x 1 matrix of variances
%      PC: each column of the matrix

[M, N] = size(data);

% Find the mean and subtract it for each dimension
data = data - repmat(m, 1, N);

% Compute the covariance matrix
covariance = (1 / (N-1)) * data * data';

% Find the eigenstuff
[PC, V] = eig(covariance);

% Create a vector with the diagonals of the matrix
V = diag(V);

% Sort the vector in decreasing order
[~, reindex] = sort(-1 * V);
V = V(reindex);
PC = PC(:, reindex);

% Project the data
signals = PC' * data;