% From https://www.mathworks.com/content/dam/mathworks/mathworks-dot-com/moler/eigs.pdf

A = [47 15; 93 35; 53 15; 45 10; 67 27; 42 10]

[U,S,V] = svd(A,0);
sigma = diag(S)

% sigma(1) >> sigma(2)
% rank 1 approx
E1 = sigma(1)*U(:,1)*V(:,1)'

% underlying PC
w = sigma(1)*U(:,1);

% We can approximate each column by
% height ? w*V(1,1)
% weight ? w*V(2,1)

height = w*V(1,1);
weight = w*V(2,1);

h_pca(:,1) = A(:,1);
h_pca(:,2) = height;
figure;
bar(h_pca); legend('actual', 'approx');title('height');
figure;
w_pca(:,1) = A(:,2);
w_pca(:,2) = weight;
bar(w_pca); legend('actual', 'approx');title('weight');
