FONTSIZE = 18;
MARKERSIZE = 15;
LINEWIDTH=3;

set(0,'DefaultAxesFontSize',FONTSIZE)
set(0,'defaultlinelinewidth',LINEWIDTH)
set(0,'DefaultLineMarkerSize',15)

% printPrefixName = '../tex/figures/';
pathseperator = '/';
printPrefixName = ['figExport' pathseperator];
N = 3;
scale = 2;

load ('annotations.mat'); % load p
% for j = 1:size(p,1)
for j = 1
    n = 0;
    pJ = scaleBoneFractionParameters({p{j,:}}, scale);
    inputFilename     = pJ{1};
    [~, fn, fe]       = fileparts(inputFilename);
    % inputFilename     = ['halfSizeData_error' pathseperator fn fe];
    inputFilename     = ['halfSizeData_error' printPrefixName '5.05_ID1662_769_v7.3_uint8.mat'];
    aBoneExample      = pJ{2};
    aCavityExample    = pJ{3};
    anImplantExample  = pJ{4};
    avoidEdgeDistance = pJ{5};
    minSlice          = pJ{6};
    maxSlice          = pJ{7};
    halfEdgeSize      = pJ{8};
    filterRadius      = pJ{9};
    maxIter           = pJ{10};
    maxDistance       = pJ{11};

    SHOWRESULT = false;
    SAVERESULT = true;
    % outputFilenamePrefix = pJ{14};
    outputFilenamePrefix = 'halfSizeData_error/5.05_ID1662_769_v7.3_double_';
    origo = pJ{15};
    R = pJ{16};
    marks = pJ{17};
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

    xMax = round(size(newVol)/2);
    x1 = 0;
    x2 = -(xMax(2)-1):xMax(2);
    x3 = -(xMax(3)-1):xMax(3);
    textDir = sign(dot(marks(end,:)-marks(1,:),[0,0,1]));
    slice = squeeze(sample3d(newVol,origo,R,x1,x2,x3));
    imagesc(slice); colormap(gray); axis image; axis image tight; xlabel('x/voxels'); ylabel('y/voxels');
    hold on;
    for i = 1:size(marks,1)
        plot(marks(i,3)*ones(i,2),[1,size(slice,1)],'r-');
        if (i < size(marks,1))
            text(marks(i,3)+textDir*1.5*FONTSIZE/2,1,sprintf('Zone %d ',i),'HorizontalAlignment','right','FontSize',FONTSIZE,'Color','r','Rotation',90)
        end
    end
    hold off
    export_fig(sprintf('%s%s_%s.pdf',printPrefixName,filename,'zones'));

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
