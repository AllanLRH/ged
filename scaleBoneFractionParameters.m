%% scaleBoneFractionParameters: Scale the input parameters of the cell pl to
% different resolution, where pl is a row in p loaded from annotate.mat. If
% annotate.mat is created for a dataset with 0.25 resolution of the original,
% and the paramaters are to be used on a dataset which is 0.5 the resolution of
% the original, the parameters scale should be 2.0.
function pl = scaleBoneFractionParameters(pl, scale)
    scaleWithOffset = @(x, scale) (x-1)*scale+1;

    pl{2}  = scaleWithOffset(pl{2}, scale);   % aBoneExample
    pl{3}  = scaleWithOffset(pl{3}, scale);   % aCavityExample
    pl{4}  = scaleWithOffset(pl{4}, scale);   % anImplantExample
    pl{5}  = scaleWithOffset(pl{5}, scale);   % avoidEdgeDistance
    pl{6}  = scaleWithOffset(pl{6}, scale);   % minSlice
    pl{7}  = scaleWithOffset(pl{7}, scale);   % maxSlice
    pl{8}  = scaleWithOffset(pl{8}, scale);   % halfEdgeSize
    pl{9}  = scaleWithOffset(pl{9}, scale);   % filterRadius
    pl{11} = scaleWithOffset(pl{11}, scale);  % maxDistance
    pl{15} = scaleWithOffset(pl{15}, scale);  % origo
    pl{16} = pl{16}*scale;                    % R
    pl{17} = scaleWithOffset(pl{17}, scale);  % marks
end
