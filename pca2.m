function [signals, PC, V] = pca2(data)
% Use SVD to perform PCA
% Input:  data    - M x N matrix of input data
% Output: signals - M x N matrix of projected data
%         V       - M x 1 matrix of variances
%         PC      - N x N matrix of principal components as each column

[foo, N] = size(data);

m = mean(data, 2);

% Find the mean of each row and subtract it for each dimension
data = data - repmat(m, 1, N);

% Compute the matrix Y where each column of Y has zero mean.
% and YY' = the covariance matrix of X (C_X) = (1/(n-1))XX'.
Y = data / sqrt(N-1);

% If we calculate the SVD of Y, the columns of matrix V 
% contain the eigenvectors of Y'Y, which is C_X.
% Therefore, the columns of V are the principal components of X.
[U, S, PC] = svd(Y, 0);
% V spans the row space of Y = X' / sqrt(N-1);
% Therefore, V must also span the column space of X/sqrt(N-1)
% We can conclude that finding the principal components amounts
% to finding an orthonormal basis that spans the column space of X.

% Compute the variances
S = diag(S);
V = S .* S;

% Project the data
signals = PC' * data;
