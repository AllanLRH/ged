clear; close; home

% Example 1: First example from 'doc slice'
[x,y,z] = meshgrid(-2:.2:2,-2:.25:2,-2:.16:2);
v = x.*exp(-x.^2-y.^2-z.^2);
xslice = [-1.2,.8,2];
yslice = 2;
zslice = [-2,0];
slice(x,y,z,v,xslice,yslice,zslice)



%% Slicing At Arbitrary Angles
% You can also create slices that are oriented in arbitrary planes. To do this,

% Create a slice surface in the domain of the volume (surf, linspace).
% Orient this surface with respect to the axes (rotate).
% Get the XData, YData, and ZData of the surface.
% Use this data to draw the slice plane within the volume.
% For example, these statements slice the volume in the first example with a rotated plane. Placing these commands within a for loop "passes" the plane through the volume along the z-axis.

[x,y,z] = meshgrid(-2:.2:2,-2:.25:2,-2:.16:2);
v = x.*exp(-x.^2-y.^2-z.^2);
figure
for k = -2:.25:2
   hsp = surf(linspace(-2,2,20), linspace(-2,2,20), zeros(20) + k);
   rotate(hsp,[1,-1,1],30)
   xd = hsp.XData;
   yd = hsp.YData;
   zd = hsp.ZData;
   delete(hsp)

   slice(x,y,z,v,[-2,2],2,-2) % Draw some volume boundaries
   hold on
   slice(x,y,z,v,xd,yd,zd)
   hold off
   view(-5,10)
   axis([-2.5 2.5 -2 2 -2 4])
   drawnow
end


%% Slicing with a Nonplanar Surface
% You can slice the volume with any surface. This example probes the volume created in the previous example by passing a spherical slice surface through the volume.

[xsp,ysp,zsp] = sphere;
slice(x,y,z,v,[-2,2],2,-2)
for i = -3:.2:3
   hsp = surface(xsp+i,ysp,zsp);
   rotate(hsp,[1 0 0],90)
   xd = hsp.XData;
   yd = hsp.YData;
   zd = hsp.ZData;
   delete(hsp)
   hold on
   hslicer = slice(x,y,z,v,xd,yd,zd);
   axis tight
   xlim([-3,3])
   view(-10,35)
   drawnow
   delete(hslicer)
   hold off
end
