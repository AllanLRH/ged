set(0,'DefaultAxesFontSize',18)
linewidth=3;
set(0,'defaultlinelinewidth',linewidth)
set(0,'DefaultLineMarkerSize',15)

printPrefixName = '../tex/figures/';
N = 3;

load ('annotations.mat'); % load p
for j = 1:size(p,1)
    n = 0;
    
    inputFilename = p{j,1};
    aBoneExample = p{j,2};
    aCavityExample = p{j,3};
    anImplantExample = p{j,4};
    avoidEdgeDistance = p{j,5};
    minSlice = p{j,6};
    maxSlice = p{j,7};
    halfEdgeSize = p{j,8};
    filterRadius = p{j,9};
    maxIter = p{j,10};
    maxDistance = p{j,11};
    SHOWRESULT = false;
    SAVERESULT = true;
    outputFilenamePrefix = p{j,14};
    origo = p{j,15};
    R = p{j,16};
    marks = p{j,17};
    %    analyse3d(inputFilename, aBoneExample, aCavityExample, anImplantExample, avoidEdgeDistance, minSlice, maxSlice, halfEdgeSize, filterRadius, maxIter, maxDistance, SHOWRESULT, SAVERESULT, origo, R, marks, outputFilename);

    [pathstr, filename, ext] = fileparts(inputFilename);
    
    load(inputFilename);
    slices = round(linspace(1,size(newVol,3),N+2));
    slices = slices(2:end-1);
    
    load([outputFilenamePrefix,'params.mat']);%'inputFilename','aBoneExample','aCavityExample','anImplantExample','avoidEdgeDistance','avoidEdgeDistance','filterRadius','maxIter','maxDistance','origo','R','marks');
    for i = slices
        clf; set(gcf,'color',[1,1,1]);
        showSlice = i;
        imagesc(newVol(:,:,showSlice)); colormap(gray); axis image tight; xlabel('x/voxels'); ylabel('y/voxels');
        export_fig(sprintf('%s%s_%s_%d.pdf',printPrefixName,filename,'original_slice',showSlice));
    end
    
    load([outputFilenamePrefix,'masks.mat']);%,'implant','circularRegionOfInterest','x3RegionOfInterest','mask');
    clf; set(gcf,'color',[1,1,1]);
    isosurface(implant,0.5); xlabel('x/voxels'); ylabel('y/voxels'); zlabel('z/voxels'); axis equal tight
    export_fig(sprintf('%s%s_%s.png',printPrefixName,filename,'implant'),'-m2');
    
    load([outputFilenamePrefix,'segments.mat']);%,'meanImg','boneMask','cavityMask','neitherMask');
    for i = slices
        clf; set(gcf,'color',[1,1,1]);
        showSlice = i;
        imagesc(meanImg(:,:,showSlice)); colormap(gray); axis image tight; xlabel('x/voxels'); ylabel('y/voxels');
        export_fig(sprintf('%s%s_%s_%d.pdf',printPrefixName,filename,'bias_corrected_slice',showSlice)); 
        imagesc(mask(:,:,showSlice)); colormap(gray); axis image tight; xlabel('x/voxels'); ylabel('y/voxels');
        export_fig(sprintf('%s%s_%s_%d.pdf',printPrefixName,filename,'mask_slice',showSlice)); 
        imagesc(cavityMask(:,:,showSlice)); colormap(gray); axis image tight; xlabel('x/voxels'); ylabel('y/voxels');
        export_fig(sprintf('%s%s_%s_%d.pdf',printPrefixName,filename,'cavities_slice',showSlice)); 
        imagesc(boneMask(:,:,showSlice)); colormap(gray); axis image tight; xlabel('x/voxels'); ylabel('y/voxels');
        export_fig(sprintf('%s%s_%s_%d.pdf',printPrefixName,filename,'bone_slice',showSlice)); 
        imagesc(neitherMask(:,:,showSlice).*meanImg(:,:,showSlice)); colormap(gray); axis image tight; xlabel('x/voxels'); ylabel('y/voxels');
        export_fig(sprintf('%s%s_%s_%d.pdf',printPrefixName,filename,'neither_slice',showSlice)); 
        hist(meanImg(neitherMask(:,:,showSlice)),1000); axis tight; xlabel('x/voxels'); ylabel('y/voxels');
        export_fig(sprintf('%s%s_%s_%d.pdf',printPrefixName,filename,'neither_histogram_slice',showSlice)); 
    end
    
    load([outputFilenamePrefix,'edgeEffect.mat']);%,'bands','sumImgByBandsFromBone','sumImgByBandsFromCavity');
    clf; set(gcf,'color',[1,1,1]);
    b = linspace(min(bands),max(bands),100); plot(b,interp1(bands,sumImgByBandsFromBone,b,'pchip')); axis tight; xlabel('distance/voxels'); ylabel('intensity');
    export_fig(sprintf('%s%s_%s.pdf',printPrefixName,filename,'edge_effect_bone'));
    b = linspace(min(bands),max(bands),100); plot(b,interp1(bands,sumImgByBandsFromCavity,b,'pchip')); axis tight; xlabel('distance/voxels'); ylabel('intensity');
    export_fig(sprintf('%s%s_%s.pdf',printPrefixName,filename,'edge_effect_cavity'));
    
    load([outputFilenamePrefix,'fractions.mat']);%,'fractions');
    for i = 1:size(fractions,1)
        clf; set(gcf,'color',[1,1,1]);
        minSlice = round(fractions{i}{1});
        maxSlice = round(fractions{i}{2});
        bone = fractions{i}{3};
        cavity = fractions{i}{4};
        neither = fractions{i}{5};
        distances = fractions{i}{6};
       
        plot(distances, bone); xlabel('distance/voxels'); ylabel('fraction');
        export_fig(sprintf('%s%s_%s_%d.pdf',printPrefixName,filename,'bone_fraction',i));
        plot(distances, cavity); xlabel('distance/voxels'); ylabel('fraction');
        export_fig(sprintf('%s%s_%s_%d.pdf',printPrefixName,filename,'cavity_fraction',i));
        plot(distances, neither); xlabel('distance/voxels'); ylabel('fraction');
        export_fig(sprintf('%s%s_%s_%d.pdf',printPrefixName,filename,'neither_fraction',i));
    end
end
