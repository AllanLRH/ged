%% getRotMat: Returns a rotation matrix
function rotMat = getRotMat(angles)
    x = angles(1);
    y = angles(2);
    z = angles(3);
    rotMat = [ cos(x)*cos(y), sin(x)*sin(z) + cos(x)*cos(z)*sin(y), cos(x)*sin(y)*sin(z) - cos(z)*sin(x);
               -sin(y), cos(y)*cos(z), cos(y)*sin(z);
               cos(y)*sin(x), cos(z)*sin(x)*sin(y) - cos(x)*sin(z), cos(x)*cos(z) + sin(x)*sin(y)*sin(z)];

 % rotx = @(x, v) = [cos(x) 0 -sin(x); 0 1 0; sin(x) 0 cos(x)] * v;
 % roty = @(y, v) = [cos(y) sin(y) 0; -sin(y) cos(y) 0; 0 0 1] * v;
 % rotz = @(z, v) = [ 1 0 0; 0 cos(z) sin(z); 0 -sin(z) cos(z)] * v;
end
