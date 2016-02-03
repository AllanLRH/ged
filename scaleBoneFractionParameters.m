%% scaleBoneFractionParameters: Scale the input parameters of the struct pp,
% representing a single dataset, to different resolution, where pp is a
% substruct from the struct p loaded from annotate.mat. If annotate.mat is
% created for a dataset with 0.25 resolution of the original, and the
% paramaters are to be used on a dataset which is 0.5 the resolution of the
% original, the parameters scale should be 2.0.
function pp = scaleBoneFractionParameters(pp, scale)
    scaleWithOffset = @(x, scale) (x-1)*scale+1;

    pp.aBoneExample      = scaleWithOffset(pp.aBoneExample,       scale);
    pp.aCavityExample    = scaleWithOffset(pp.aCavityExample,     scale);
    pp.anImplantExample  = scaleWithOffset(pp.anImplantExample,   scale);
    pp.avoidEdgeDistance = pp.avoidEdgeDistance*scale;
    pp.minSlice          = scaleWithOffset(pp.minSlice,           scale);
    pp.maxSlice          = scaleWithOffset(pp.maxSlice,           scale);
    pp.halfEdgeSize      = pp.halfEdgeSize*scale;
    pp.filterRadius      = pp.filterRadius*scale;
    pp.maxDistance       = pp.maxDistance*scale;
    pp.origo             = scaleWithOffset(pp.origo,              scale);
    pp.R                 = pp.R;
    pp.marks             = scaleWithOffset(pp.marks,              scale);
end
