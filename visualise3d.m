% Global plotting parameters
FONTSIZE = 18;
MARKERSIZE = 15;
LINEWIDTH=3;

% Visualization parameters
numberSlicesToShow = 3; % The number of exemplar slices generated

% Prefixes for the data files
%printPrefixName = '../tex/figures/';
%pathseperator = '/';
%printPrefixName = ['figExport' pathseperator];
annotationsPrefix = fullfile('~','AKIRA','ged'); % Annotation file prefix (input)
scaleFactor = 2; % scaling factor used in the analysis fase w.r.t. annotation file
analysisPrefix = fullfile('~','AKIRA','ged','halfSizeData'); % Analysis files prefix (input)
pdfPrefix = fullfile('..','tex','figuresMedium'); % pdf filename prefix (output)

%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
set(0,'DefaultAxesFontSize',FONTSIZE)
set(0,'defaultlinelinewidth',LINEWIDTH)
set(0,'DefaultLineMarkerSize',15)

load(fullfile(annotationsPrefix,'annotations.mat')); % load p
names = fieldnames(p);
for j = 1:1%length(names)
    n = 0;
    pJ = scaleBoneFractionParameters(p.(names{j}), scaleFactor);
    [fp, fn, fe] = fileparts(pJ.inputFilename);
    % We may have moved stuff, so we override path
    load(fullfile(analysisPrefix,[fn,fe]));
    
    slices = round(linspace(1,size(newVol,3),numberSlicesToShow+2));
    slices = slices(2:end-1);
    
    load(fullfile(analysisPrefix,[fn,'_params.mat']));%'inputFilename','aBoneExample','aCavityExample','anImplantExample','avoidEdgeDistance','avoidEdgeDistance','filterRadius','maxIter','maxDistance','origo','R','marks');
    for i = slices
        clf; set(gcf,'color',[1,1,1]);
        showSlice = i;
        imagesc(newVol(:,:,showSlice)); colormap(gray); axis image tight; xlabel('x/voxels'); ylabel('y/voxels');
        export_fig(fullfile(pdfPrefix,sprintf('%s_%s_%d.pdf',fn,'original_slice',showSlice)));
    end
    
    load(fullfile(analysisPrefix,[fn,'_masks.mat']));%,'implant','circularRegionOfInterest','x3RegionOfInterest','mask');
    clf; set(gcf,'color',[1,1,1]);
    isosurface(implant,0.5); xlabel('x/voxels'); ylabel('y/voxels'); zlabel('z/voxels'); axis equal tight
    export_fig(fullfile(pdfPrefix,sprintf('%s_%s.png',fn,'implant')),'-m2');
    
    xMax = round(size(newVol)/2);
    x1 = 0;
    x2 = -(xMax(2)-1):xMax(2);
    x3 = -(xMax(3)-1):xMax(3);
    textDir = sign(dot(pJ.marks(end,:)-pJ.marks(1,:),[0,0,1]));
    slice = squeeze(sample3d(newVol,pJ.origo,pJ.R,x1,x2,x3));
    imagesc(slice); colormap(gray); axis image; axis image tight; xlabel('x/voxels'); ylabel('y/voxels');
    hold on;
    for i = 1:size(pJ.marks,1)
        plot(pJ.marks(i,3)*ones(i,2),[1,size(slice,1)],'r-');
        if (i < size(pJ.marks,1))
            text(pJ.marks(i,3)+textDir*1.5*FONTSIZE/2,1,sprintf('Zone %d ',i),'HorizontalAlignment','right','FontSize',FONTSIZE,'Color','r','Rotation',90)
        end
    end
    hold off
    export_fig(fullfile(pdfPrefix,sprintf('%s_%s.pdf',fn,'zones')));
    
    load(fullfile(analysisPrefix,[fn,'_segments.mat']));%,'meanImg','boneMask','cavityMask','neitherMask');
    for i = slices
        clf; set(gcf,'color',[1,1,1]);
        showSlice = i;
        imagesc(meanImg(:,:,showSlice)); colormap(gray); axis image tight; xlabel('x/voxels'); ylabel('y/voxels');
        export_fig(fullfile(pdfPrefix,sprintf('%s_%s_%d.pdf',fn,'bias_corrected_slice',showSlice)));
        imagesc(mask(:,:,showSlice)); colormap(gray); axis image tight; xlabel('x/voxels'); ylabel('y/voxels');
        export_fig(fullfile(pdfPrefix,sprintf('%s_%s_%d.pdf',fn,'mask_slice',showSlice)));
        imagesc(cavityMask(:,:,showSlice)); colormap(gray); axis image tight; xlabel('x/voxels'); ylabel('y/voxels');
        export_fig(fullfile(pdfPrefix,sprintf('%s_%s_%d.pdf',fn,'cavities_slice',showSlice)));
        imagesc(boneMask(:,:,showSlice)); colormap(gray); axis image tight; xlabel('x/voxels'); ylabel('y/voxels');
        export_fig(fullfile(pdfPrefix,sprintf('%s_%s_%d.pdf',fn,'bone_slice',showSlice)));
        imagesc(neitherMask(:,:,showSlice).*meanImg(:,:,showSlice)); colormap(gray); axis image tight; xlabel('x/voxels'); ylabel('y/voxels');
        export_fig(fullfile(pdfPrefix,sprintf('%s_%s_%d.pdf',fn,'neither_slice',showSlice)));
        hist(meanImg(neitherMask(:,:,showSlice)),1000); axis tight; xlabel('x/voxels'); ylabel('y/voxels');
        export_fig(fullfile(pdfPrefix,sprintf('%s_%s_%d.pdf',fn,'neither_histogram_slice',showSlice)));
    end
    
    load(fullfile(analysisPrefix,[fn,'_edgeEffect.mat']));%,'bands','sumImgByBandsFromBone','sumImgByBandsFromCavity');
    clf; set(gcf,'color',[1,1,1]);
    b = linspace(min(bands),max(bands),100); plot(b,interp1(bands,sumImgByBandsFromBone,b,'pchip')); axis tight; xlabel('distance/voxels'); ylabel('intensity');
    export_fig(fullfile(pdfPrefix,sprintf('%s_%s.pdf',fn,'edge_effect_bone')));
    b = linspace(min(bands),max(bands),100); plot(b,interp1(bands,sumImgByBandsFromCavity,b,'pchip')); axis tight; xlabel('distance/voxels'); ylabel('intensity');
    export_fig(fullfile(pdfPrefix,sprintf('%s_%s.pdf',fn,'edge_effect_cavity')));
    
    load(fullfile(analysisPrefix,[fn,'_fractions.mat']));%,'fractions');
    for i = 1:size(fractions,1)
        clf; set(gcf,'color',[1,1,1]);
        minSlice = round(fractions{i}{1});
        maxSlice = round(fractions{i}{2});
        bone = fractions{i}{3};
        cavity = fractions{i}{4};
        neither = fractions{i}{5};
        distances = fractions{i}{6};
        
        plot(distances, bone); xlabel('distance/voxels'); ylabel('fraction');
        export_fig(fullfile(pdfPrefix,sprintf('%s_%s_%d.pdf',fn,'bone_fraction',i)));
        plot(distances, cavity); xlabel('distance/voxels'); ylabel('fraction');
        export_fig(fullfile(pdfPrefix,sprintf('%s_%s_%d.pdf',fn,'cavity_fraction',i)));
        plot(distances, neither); xlabel('distance/voxels'); ylabel('fraction');
        export_fig(fullfile(pdfPrefix,sprintf('%s_%s_%d.pdf',fn,'neither_fraction',i)));
    end
end
