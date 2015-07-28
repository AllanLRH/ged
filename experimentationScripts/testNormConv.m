clear; home; close all;


n = 2^8; % Størrelse på billede
m = 10; % Størrelse på filter
sigma = 10; % std afvigelse på støj
mu = 100; % middel væredi på støj

% Træk et tilfældigt billede
I = sigma*randn(n,n)+mu;
% Lav den tilhørende maske
M = zeros(n,n);
M((n/2+1):n,:) = 1;
I = I.*M;
% Lav en foldningskerne
K = ones(m,m)/m^2;

% Lokale means
f = @(I,K,M) conv2(I.*M,K,'same')./conv2(M,K,'same');
J = f(I,K,ones(size(I)));
L = f(I,K,M); L(~M)=0;

% Lokale varianser
g = @(I,K,M) conv2((I.*M).^2,K,'same')./conv2(M,K,'same') - (conv2(I.*M,K,'same')./conv2(M,K,'same')).^2;
Js = g(I,K,ones(size(I)));
Ls = g(I,K,M); Ls(~M)=0;

LL = getMeanImage(I, M, size(K, 1));

LL_L_diff = sum(sum(imabsdiff(L, LL)))

LLs = getVarImage(I, M, size(K, 1));

LLs_Ls_diff = sum(sum(imabsdiff(Ls, LLs)))

