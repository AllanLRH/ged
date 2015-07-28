N = 50;

N2 = round(N/2);
I = zeros(N,N,N);
I(N2+(-5:5),N2+(-10:10),N2+(-20:20)) = 1;
%w = [1,1,1]';
w = randn(3,1);
x = N2*ones(3,1);
J = sample3d(I,x,[1,0,0]',w,(-(N2-1):N2),(-(N2-1):N2),(-(N2-1):N2));

M = J>0.5;
[w,x] = getMajorAxis(J>0.5);
K = sample3d(J,x,[1,0,0]',w,-(N2-1):N2,-(N2-1):N2,10:30);

figure(1);
clf; isosurface(I,.5); axis equal, view(3)
xlabel('x');
ylabel('y');
zlabel('z');


figure(2);
clf; isosurface(J,.5); axis equal, view(3)
xlabel('x');
ylabel('y');
zlabel('z');

figure(3);
if(size(K,3)>1)
    clf; isosurface(K,.5); axis equal, view(3)
    xlabel('x');
    ylabel('y');
    zlabel('z');
else
    clf; imagesc(K); axis equal, colormap(gray); colorbar;
    xlabel('x');
    ylabel('y');
end

L = sample3d(I,x,[1,1,0]',w,(-(N2-1):N2),(-(N2-1):N2),0);
clf; imagesc(L); axis equal, colormap(gray); colorbar;
xlabel('x');
ylabel('y');
