% From https://www.mathworks.com/content/dam/mathworks/mathworks-dot-com/moler/eigs.pdf

load detail
subplot(2,2,1)
image(X)
colormap(gray(64))
axis image, axis off
r = rank(X) % full rank
title(['rank = ' int2str(r)])

[U,S,V] = svd(X,0);
sigma = diag(S);


semilogy(sigma,'.')