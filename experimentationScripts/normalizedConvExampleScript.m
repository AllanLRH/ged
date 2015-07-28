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
K = ones(m,m);

% Lokale means
f = @(I,K,M) conv2(I.*M,K,'same')./conv2(M,K,'same');
J = f(I,K,ones(size(I)));
L = f(I,K,M); L(~M)=0;

% Lokale varianser
g = @(I,K,M) conv2((I.*M).^2,K,'same')./conv2(M,K,'same') - (conv2(I.*M,K,'same')./conv2(M,K,'same')).^2;
Js = g(I,K,ones(size(I)));
Ls = g(I,K,M); Ls(~M)=0;

% Plot af billeder
figure(1); clf;
subplot(1,3,1); imagesc(I); xlim([m,size(Js,1)-m]); ylim([m,size(Js,2)-m]); colormap(gray); axis image; title('original'); colorbar;
subplot(1,3,2); imagesc(J); xlim([m,size(Js,1)-m]); ylim([m,size(Js,2)-m]); colormap(gray); axis image; title('conv'); colorbar;
subplot(1,3,3); imagesc(L); xlim([m,size(Js,1)-m]); ylim([m,size(Js,2)-m]); colormap(gray); axis image; title('normalized conv'); colorbar;

% Plot af gennemsnit af mean
figure(2); clf;
plot(mean(I,2),'k');
hold on;
plot(mean(J,2),'b','linewidth', 2);
plot(mean(L,2),'g');
hold off;
xlim([m,size(Js,1)-m]);

% Plot af gennemsnit af var
figure(3); clf;
plot(mean(Js,2),'b');
hold on;
plot(mean(Ls,2),'g');
hold off;
xlim([m,size(Js,1)-m]);
