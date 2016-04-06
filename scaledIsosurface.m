function scaledIsosurface(vol)
    % scaledIsosurface: Compute a small volume from a bigger where the volume
    % size must be 2s x 2s x s, for instance 512 x 512 x 256.
    % Once rescaled the `isosurface(vol > 0.5)` is called
    if size(vol, 1) ~= size(vol, 2) || size(vol, 1) ~= size(vol, 3)/2
        error('Volume size must be 2s x 2s x s, for instance 512 x 512 x 256')
    end
   [xq, yq, zq] = ndgrid(1:64, 1:64, 1:32);
   vq = interpn(single(vol), xq, yq, zq);
   figure
   isosurface(vq > 0.5)
end
