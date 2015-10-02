clear; close all; home

load mri; clear map siz
D = squeeze(D);

pt = size(D)/2;
vec = [1 10 1]; vec = vec/norm(vec)
[slice, subX, subY, subZ] = extractSlice(D, pt(1), pt(2), pt(3), vec(1), vec(2), vec(3), 64);
surf(subX, subY, subZ, slice, 'FaceColor', 'texturemap', 'EdgeColor', 'none');
colormap('bone')
axis([1 130 1 130 1 40]);
% drawnow;
xlabel('x')
xlim([-20 140])
ylabel('y')
ylim([-20 140])
zlabel('z')
zlim([-10 50])
colorbar



% for i = 0:2.5:30;
%     pt = [64 i*2 14];
%     vec = [0 30-i i]
%     [slice, subX, subY, subZ] = extractSlice(D, pt(1), pt(2), pt(3), vec(1), vec(2), vec(3), 64);
%     surf(subX, subY, subZ, slice, 'FaceColor', 'texturemap', 'EdgeColor', 'none');
%     colormap('bone')
%     axis([1 130 1 130 1 40]);
%     drawnow;
%     pause(0.2)
% end;
