[x,y,z,v] = flow;
p = patch(isosurface(x,y,z,v,-3));
isonormals(x,y,z,v,p)
p.FaceColor = 'red';
p.EdgeColor = 'none';
daspect([1,1,1])
view(3); axis tight
camlight
lighting gouraud
set(p,'ButtonDownFcn',@(a,b)eval('hold on; plot3(b.IntersectionPoint(1),b.IntersectionPoint(2),b.IntersectionPoint(3),''o''); hold off'))
