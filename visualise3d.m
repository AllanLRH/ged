function visualise3d(setup, parametersSuffix, masksSuffix, segmentsSuffix, edgeEffectSuffix, fractionsSuffix, numberSlicesToShow, fid, FONTSIZE, SMALLFONTSIZE, MARKERSIZE, LINEWIDTH, PROGRESSOUTPUT, VERBOSE)
%

tic;

% Prefixes for the data files
imageFilename = setup.imageFilename;
%scaleFactor = setup.scaleFactor;
inputFilenamePrefix = setup.inputFilenamePrefix;
MicroMeterPerPixel = setup.MicroMeterPerPixel;
figurePrefix = setup.figurePrefix;

%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
set(0,'DefaultAxesFontSize',FONTSIZE)
set(0,'defaultlinelinewidth',LINEWIDTH)
set(0,'DefaultLineMarkerSize',MARKERSIZE)

%p = scaleBoneFractionParameters(setup, scaleFactor);

newVol = loadImage(imageFilename, VERBOSE, PROGRESSOUTPUT);

slices = round(linspace(1,size(newVol,3),numberSlicesToShow+2));
slices = slices(2:end-1);

inputFilename = [inputFilenamePrefix,parametersSuffix];
if ~exist(inputFilename,'file')
    if PROGRESSOUTPUT
        fprintf('  ''%s'' does not exist, moving on to next (%gs)\n', inputFilenamePrefix, toc);
        tic;
    end
else
    [marks, origo, R] = visualizeImageSections(newVol, slices, MicroMeterPerPixel, figurePrefix, inputFilenamePrefix, parametersSuffix, fid, VERBOSE, PROGRESSOUTPUT);
    
    [mask, rotatedImplant] = visualizeImplant(newVol, origo, R, marks, MicroMeterPerPixel, figurePrefix, inputFilenamePrefix, masksSuffix, fid, FONTSIZE, SMALLFONTSIZE, VERBOSE, PROGRESSOUTPUT);
    
    visualizeSegments(mask, MicroMeterPerPixel, slices, figurePrefix, inputFilenamePrefix, segmentsSuffix, fid, VERBOSE, PROGRESSOUTPUT);
    
    visualizeBands(MicroMeterPerPixel, figurePrefix, inputFilenamePrefix, edgeEffectSuffix, fid, VERBOSE, PROGRESSOUTPUT);
    
    visualizeFractions(newVol, marks, rotatedImplant, origo, MicroMeterPerPixel, figurePrefix, inputFilenamePrefix, fractionsSuffix, fid, SMALLFONTSIZE, VERBOSE, PROGRESSOUTPUT);
end
end

function newVol = loadImage(imageFilename, VERBOSE, PROGRESSOUTPUT)
%
if VERBOSE
    fprintf('  loading %s\n',imageFilename);
end
load(imageFilename,'newVol'); % loads newVol
if PROGRESSOUTPUT
    fprintf('  image file read (%gs)\n',toc);
    tic;
end
end

function [marks, origo, R] = visualizeImageSections(newVol, slices, MicroMeterPerPixel, figurePrefix, inputFilenamePrefix, parametersSuffix, fid, VERBOSE, PROGRESSOUTPUT)
%
inputFilename = [inputFilenamePrefix,parametersSuffix];

if VERBOSE
    fprintf('  loading %s\n',inputFilename);
end
load(inputFilename,'inputFilename','aBoneExample','aCavityExample','anImplantExample','avoidEdgeDistance','avoidEdgeDistance','filterRadius','maxIter','maxDistance','origo','R','marks');
if ~isempty(fid)
    fprintf(fid, '\\begin{figure}[ht]\n  \\centering\n');
    [~, fn, fe] = fileparts(figurePrefix);
    fnEsc = strrep([fn,fe], '_', '\_'); % Prefix has no suffix
    caption = sprintf('%s: Original image sections.',fnEsc);
end
for i = slices
    clf; set(gcf,'color',[1,1,1]);
    showSlice = i;
    imagesc(newVol(:,:,showSlice)); colormap(gray); axis image tight;
    convertUnit('xtick','xticklabel',MicroMeterPerPixel); xlabel('x/\mum');
    convertUnit('ytick','yticklabel',MicroMeterPerPixel); ylabel('y/\mum');
    outputFilename = [figurePrefix,sprintf('%s_%d.pdf','original_slice',showSlice)];
    if VERBOSE
        fprintf('  saving %s\n',outputFilename);
    end
    export_fig(outputFilename);
    if ~isempty(fid)
        fprintf(fid, '  \\subfigure[z=%d voxels]{\\includegraphics[width=0.3\\linewidth]{%s}}\n', i, outputFilename);
    end
end
if ~isempty(fid)
    fprintf(fid, '  \\caption{%s}\n\\end{figure}\n', caption);
end
if PROGRESSOUTPUT
    fprintf('  %s file read and printed (%gs)\n',parametersSuffix,toc);
    tic;
end
end

function [mask, rotatedImplant] = visualizeImplant(newVol, origo, R, marks, MicroMeterPerPixel, figurePrefix, inputFilenamePrefix, masksSuffix, fid, FONTSIZE, SMALLFONTSIZE, VERBOSE, PROGRESSOUTPUT)
%
inputFilename = [inputFilenamePrefix,masksSuffix];

if VERBOSE
    fprintf('  loading %s\n',inputFilename);
end
load(inputFilename,'implant','circularRegionOfInterest','x3RegionOfInterest','mask');
if ~isempty(fid)
    fprintf(fid, '\\begin{figure}[ht]\n  \\centering\n');
    [~, fn, fe] = fileparts(figurePrefix);
    fnEsc = strrep([fn,fe], '_', '\_'); % Prefix has no suffix
    caption = sprintf('%s: Implant.',fnEsc);
end
clf; set(gcf,'color',[1,1,1]);
xMax = round(size(newVol)/2);
x1 = -(xMax(1)-1):xMax(1);
x2 = -(xMax(2)-1):xMax(2);
x3 = -(xMax(3)-1):xMax(3);
rotatedImplant = sample3d(single(implant),origo,R,x1,x2,x3)>.5;
isosurface(rotatedImplant(1:2:size(rotatedImplant,1),1:2:size(rotatedImplant,2),1:2:size(rotatedImplant,3)),0.5);
axis equal tight
convertUnit('xtick','xticklabel',2*MicroMeterPerPixel); xlabel('x/\mum');
convertUnit('ytick','yticklabel',2*MicroMeterPerPixel); ylabel('y/\mum');
convertUnit('ztick','zticklabel',2*MicroMeterPerPixel); zlabel('z/\mum');
v = (marks(1,:)-marks(end,:))'; v = v/norm(v);
%w = cross(rand(3,1)-0.5,v); w = w/norm(w);
w = cross([1,0.75,0]',v); w = w/norm(w);
set(gca,'CameraUpVector',v)
set(gca,'CameraTarget',origo/2)
set(gca,'CameraPosition',marks(1,:)/2+2*size(newVol,1)*w'/2)
set(gca,'FONTSIZE',SMALLFONTSIZE)
set(gca,'Position', get(gca,'Position') - [0.05,0,0,0])
delete(findall(gcf,'Type','light'))
camlight('left')
camlight('right')
outputFilename = [figurePrefix,sprintf('%s.png','implant')];
if VERBOSE
    fprintf('  saving %s\n',outputFilename);
end
export_fig(outputFilename,'-m2');
if ~isempty(fid)
    fprintf(fid, '  \\subfigure{\\includegraphics[width=0.3\\linewidth]{%s}}\n', outputFilename);
    fprintf(fid, '  \\caption{%s}\n\\end{figure}\n', caption);
end

if ~isempty(fid)
    fprintf(fid, '\\begin{figure}[ht]\n  \\centering\n');
    [~, fn, fe] = fileparts(figurePrefix);
    fnEsc = strrep([fn,fe], '_', '\_'); % Prefix has no suffix
    caption = sprintf('%s: Zones.',fnEsc);
end
xMax = round(size(newVol)/2);
x1 = 0;
x2 = -(xMax(2)-1):xMax(2);
x3 = -(xMax(3)-1):xMax(3);
textDir = sign(dot(marks(end,:)-marks(1,:),[0,0,1]));
slice = squeeze(sample3d(newVol,origo,R,x1,x2,x3));
imagesc(slice); colormap(gray); axis image tight;
convertUnit('xtick','xticklabel',MicroMeterPerPixel); xlabel('z/\mum');
convertUnit('ytick','yticklabel',MicroMeterPerPixel); ylabel('x/\mum');
hold on;
for i = 1:size(marks,1)
    plot(marks(i,3)*ones(i,2),[1,size(slice,1)],'r-');
    if (i < size(marks,1))
        text(marks(i,3)+textDir*2*FONTSIZE*2/3,1,sprintf('Zone %d ',i),'HorizontalAlignment','right','FontSize',FONTSIZE,'Color','r','Rotation',90)
    end
end
hold off
outputFilename = [figurePrefix,sprintf('%s.pdf','zones')];
if VERBOSE
    fprintf('  saving %s\n',outputFilename);
end
export_fig(outputFilename);
if ~isempty(fid)
    fprintf(fid, '  \\subfigure{\\includegraphics[width=0.3\\linewidth]{%s}}\n', outputFilename);
end

imagesc(fliplr(slice')); colormap(gray); axis image tight;
convertUnit('xtick','xticklabel',MicroMeterPerPixel); xlabel('x/\mum');
convertUnit('ytick','yticklabel',MicroMeterPerPixel); ylabel('z/\mum');
hold on;
for i = 1:size(marks,1)
    plot([1,size(slice,1)],marks(i,3)*ones(i,2),'r-');
    if (i < size(marks,1))
        text(10,marks(i,3)+textDir*2*FONTSIZE*2/3,sprintf('Zone %d ',i),'FontSize',FONTSIZE,'Color','r')
    end
end
hold off
outputFilename = [figurePrefix,sprintf('%s_rotated.pdf','zones')];
if VERBOSE
    fprintf('  saving %s\n',outputFilename);
end
export_fig(outputFilename);
if ~isempty(fid)
    fprintf(fid, '  \\subfigure{\\includegraphics[width=0.6\\linewidth]{%s}}\n', outputFilename);
end
if ~isempty(fid)
    fprintf(fid, '  \\caption{%s}\n\\end{figure}\n', caption);
end

if ~isempty(fid)
    fprintf(fid, '\\begin{figure}[ht]\n  \\centering\n');
    [~, fn, fe] = fileparts(figurePrefix);
    fnEsc = strrep([fn,fe], '_', '\_'); % Prefix has no suffix
    caption = sprintf('%s: Zones samples.',fnEsc);
end
for i = 1:size(marks,1)-1
    xMax = round(size(newVol)/2);
    x1 = -(xMax(1)-1):xMax(1);
    x2 = -(xMax(2)-1):xMax(2);
    x3 = -(xMax(3)-1):xMax(3);
    t = round((marks(i,3)+marks(i+1,3))/2);
    x3 = x3(t);
    %slice = squeeze(sample3d(newVol,pJ.origo,pJ.R,x1,x2,x3));
    slice = squeeze(sample3d(newVol.*mask,origo,R,x1,x2,x3));
    slice(isnan(slice))=0;
    imagesc(slice); colormap(gray); axis image tight;
    convertUnit('xtick','xticklabel',MicroMeterPerPixel); xlabel('x/\mum');
    convertUnit('ytick','yticklabel',MicroMeterPerPixel); ylabel('y/\mum');
    title(sprintf('z = %d\\mum',t*MicroMeterPerPixel));
    %pause;
    outputFilename = [figurePrefix,sprintf('%s%d_%s.pdf','zone',i,'example')];
    if VERBOSE
        fprintf('  saving %s\n',outputFilename);
    end
    export_fig(outputFilename);
    if ~isempty(fid)
        fprintf(fid, '  \\subfigure{\\includegraphics[width=0.3\\linewidth]{%s}}\n', outputFilename);
    end
end
if ~isempty(fid)
    fprintf(fid, '  \\caption{%s}\n\\end{figure}\n', caption);
end
if PROGRESSOUTPUT
    fprintf('  %s file read and printed (%gs)\n',masksSuffix, toc);
    tic;
end
end

function visualizeSegments(mask, MicroMeterPerPixel, slices, figurePrefix, inputFilenamePrefix, segmentsSuffix, fid, VERBOSE, PROGRESSOUTPUT)
%
inputFilename = [inputFilenamePrefix,segmentsSuffix];

if VERBOSE
    fprintf('  loading %s\n',inputFilename);
end
load(inputFilename,'meanImg','boneMask','cavityMask','neitherMask');
if ~isempty(fid)
    fprintf(fid, '\\begin{figure}[ht]\n  \\centering\n');
    [~, fn, fe] = fileparts(figurePrefix);
    fnEsc = strrep([fn,fe], '_', '\_'); % Prefix has no suffix
    caption = sprintf('%s: Segments.',fnEsc);
end
for i = slices
    clf; set(gcf,'color',[1,1,1]);
    showSlice = i;
    imagesc(meanImg(:,:,showSlice)); colormap(gray); axis image tight;
    convertUnit('xtick','xticklabel',MicroMeterPerPixel); xlabel('x/\mum');
    convertUnit('ytick','yticklabel',MicroMeterPerPixel); ylabel('y/\mum');
    outputFilename = [figurePrefix,sprintf('%s_%d.pdf','bias_corrected_slice',showSlice)];
    if VERBOSE
        fprintf('  saving %s\n',outputFilename);
    end
    export_fig(outputFilename);
    if ~isempty(fid)
        fprintf(fid, '  \\subfigure{\\includegraphics[width=0.24\\linewidth]{%s}}\n', outputFilename);
    end
    
    imagesc(mask(:,:,showSlice)); colormap(gray); axis image tight;
    convertUnit('xtick','xticklabel',MicroMeterPerPixel); xlabel('x/\mum');
    convertUnit('ytick','yticklabel',MicroMeterPerPixel); ylabel('y/\mum');
    outputFilename = [figurePrefix,sprintf('%s_%d.pdf','mask_slice',showSlice)];
    if VERBOSE
        fprintf('  saving %s\n',outputFilename);
    end
    export_fig(outputFilename);
    if ~isempty(fid)
        fprintf(fid, '  \\subfigure{\\includegraphics[width=0.24\\linewidth]{%s}}\n', outputFilename);
    end
    
    imagesc(cavityMask(:,:,showSlice)); colormap(gray); axis image tight;
    convertUnit('xtick','xticklabel',MicroMeterPerPixel); xlabel('x/\mum');
    convertUnit('ytick','yticklabel',MicroMeterPerPixel); ylabel('y/\mum');
    outputFilename = [figurePrefix,sprintf('%s_%d.pdf','cavities_slice',showSlice)];
    if VERBOSE
        fprintf('  saving %s\n',outputFilename);
    end
    export_fig(outputFilename);
    if ~isempty(fid)
        fprintf(fid, '  \\subfigure{\\includegraphics[width=0.24\\linewidth]{%s}}\n', outputFilename);
    end
    
    imagesc(boneMask(:,:,showSlice)); colormap(gray); axis image tight;
    convertUnit('xtick','xticklabel',MicroMeterPerPixel); xlabel('x/\mum');
    convertUnit('ytick','yticklabel',MicroMeterPerPixel); ylabel('y/\mum');
    outputFilename = [figurePrefix,sprintf('%s_%d.pdf','bone_slice',showSlice)];
    if VERBOSE
        fprintf('  saving %s\n',outputFilename);
    end
    export_fig(outputFilename);
    if ~isempty(fid)
        fprintf(fid, '  \\subfigure{\\includegraphics[width=0.24\\linewidth]{%s}}\n', outputFilename);
    end
    
    %{
    imagesc(neitherMask(:,:,showSlice).*meanImg(:,:,showSlice)); colormap(gray); axis image tight;
    convertUnit('xtick','xticklabel',MicroMeterPerPixel); xlabel('x/\mum');
    convertUnit('ytick','yticklabel',MicroMeterPerPixel); ylabel('y/\mum');
    outputFilename = [figurePrefix,sprintf('%s_%d.pdf','neither_slice',showSlice)];
    if VERBOSE
        fprintf('  saving %s\n',outputFilename);
    end
    export_fig(outputFilename);
        if ~isempty(fid)
            fprintf(fid, '  \\subfigure{\\includegraphics[width=0.24\\linewidth]{%s}}\n', outputFilename);
        end

    hist(meanImg(neitherMask(:,:,showSlice)),1000); axis tight;
    xlabel('normalised intensity');
    ylabel('frequency');
    outputFilename = [figurePrefix,sprintf('%s_%d.pdf','neither_histogram_slice',showSlice)];
    if VERBOSE
        fprintf('  saving %s\n',outputFilename);
    end
    export_fig(outputFilename);
        if ~isempty(fid)
            fprintf(fid, '  \\subfigure{\\includegraphics[width=0.24\\linewidth]{%s}}\n', outputFilename);
        end
    %}
end
if ~isempty(fid)
    fprintf(fid, '  \\caption{%s}\n\\end{figure}\n', caption);
end
if PROGRESSOUTPUT
    fprintf('  %s file read and printed (%gs)\n',segmentsSuffix,toc);
    tic;
end
end

function visualizeBands(MicroMeterPerPixel, figurePrefix, inputFilenamePrefix, edgeEffectSuffix, fid, VERBOSE, PROGRESSOUTPUT)
%
inputFilename = [inputFilenamePrefix,edgeEffectSuffix];

if VERBOSE
    fprintf('  loading %s\n',inputFilename);
end
load(inputFilename,'bands','sumImgByBandsFromBone','sumImgByBandsFromCavity');
if ~isempty(fid)
    fprintf(fid, '\\begin{figure}[ht]\n  \\centering\n');
    [~, fn, fe] = fileparts(figurePrefix);
    fnEsc = strrep([fn,fe], '_', '\_'); % Prefix has no suffix
    caption = sprintf('%s: Overshooting effect.',fnEsc);
end
clf; set(gcf,'color',[1,1,1]);
b = MicroMeterPerPixel*linspace(min(bands),max(bands),100);
plot(b,interp1(bands,sumImgByBandsFromBone,b,'pchip')); axis tight;
xlabel('distance/\mum');
ylabel('normalized intensity');
outputFilename = [figurePrefix,sprintf('%s.pdf','edge_effect_bone')];
if VERBOSE
    fprintf('  saving %s\n',outputFilename);
end
export_fig(outputFilename);
if ~isempty(fid)
    fprintf(fid, '  \\subfigure{\\includegraphics[width=0.3\\linewidth]{%s}}\n', outputFilename);
end

plot(b,interp1(bands,sumImgByBandsFromCavity,b,'pchip')); axis tight;
xlabel('distance/\mum');
ylabel('normalized intensity');
outputFilename = [figurePrefix,sprintf('%s.pdf','edge_effect_cavity')];
if VERBOSE
    fprintf('  saving %s\n',outputFilename);
end
export_fig(outputFilename);
if ~isempty(fid)
    fprintf(fid, '  \\subfigure{\\includegraphics[width=0.3\\linewidth]{%s}}\n', outputFilename);
end
if ~isempty(fid)
    fprintf(fid, '  \\caption{%s}\n\\end{figure}\n', caption);
end
if PROGRESSOUTPUT
    fprintf('  %s file read and printed (%gs)\n',edgeEffectSuffix,toc);
    tic;
end
end

function visualizeFractions(newVol, marks, rotatedImplant, origo, MicroMeterPerPixel, figurePrefix, inputFilenamePrefix, fractionsSuffix, fid, SMALLFONTSIZE, VERBOSE, PROGRESSOUTPUT)
%
inputFilename = [inputFilenamePrefix,fractionsSuffix];

if VERBOSE
    fprintf('  loading %s\n',inputFilename);
end
load(inputFilename,'fractions');
if ~isempty(fid)
    fprintf(fid, '\\begin{figure}[ht]\n  \\centering\n');
    [~, fn, fe] = fileparts(figurePrefix);
    fnEsc = strrep([fn,fe], '_', '\_'); % Prefix has no suffix
    caption = sprintf('%s: Fractions.',fnEsc);
end
for i = 1:size(fractions,1)
    clf; set(gcf,'color',[1,1,1]);
    x3RegionOfInterest = fractions{i}{1};
    %minSlice = round(fractions{i}{2});
    %maxSlice = round(fractions{i}{3});
    bone = fractions{i}{4};
    cavity = fractions{i}{5};
    neither = fractions{i}{6};
    distances = fractions{i}{7};

    % distances are right values of interval. We reset it to middle of
    % interval, assuming the first is from zero
    distances = (distances + [0,distances(1:end-1)])/2;
    
    distances = distances*MicroMeterPerPixel;
    ind = find(distances<1000);
    ind = ind(end);
    plot(distances(1:ind), bone(1:ind));
    ylim([0,1]);
    xlabel('distance/\mum');
    ylabel('fraction');
    if(i==size(fractions,1))
        outputFilename = [figurePrefix,sprintf('%s_all.pdf','bone_fraction')];
    else
        outputFilename = [figurePrefix,sprintf('%s_%d.pdf','bone_fraction',i)];
    end
    if VERBOSE
        fprintf('  saving %s\n',outputFilename);
    end
    export_fig(outputFilename);
    if ~isempty(fid)
        fprintf(fid, '  \\subfigure{\\includegraphics[width=0.24\\linewidth]{%s}}\n', outputFilename);
    end
    
    plot(distances(1:ind), cavity(1:ind));
    ylim([0,1]);
    xlabel('distance/\mum');
    ylabel('fraction');
    if(i==size(fractions,1))
        outputFilename = [figurePrefix,sprintf('%s_all.pdf','cavity_fraction')];
    else
        outputFilename = [figurePrefix,sprintf('%s_%d.pdf','cavity_fraction',i)];
    end
    if VERBOSE
        fprintf('  saving %s\n',outputFilename);
    end
    export_fig(outputFilename);
    if ~isempty(fid)
        fprintf(fid, '  \\subfigure{\\includegraphics[width=0.24\\linewidth]{%s}}\n', outputFilename);
    end
    
    plot(distances(1:ind), neither(1:ind));
    ylim([0,1]);
    xlabel('distance/\mum');
    ylabel('fraction');
    if(i==size(fractions,1))
        outputFilename = [figurePrefix,sprintf('%s_all.pdf','neither_fraction')];
    else
        outputFilename = [figurePrefix,sprintf('%s_%d.pdf','neither_fraction',i)];
    end
    if VERBOSE
        fprintf('  saving %s\n',outputFilename);
    end
    export_fig(outputFilename);
    if ~isempty(fid)
        fprintf(fid, '  \\subfigure{\\includegraphics[width=0.24\\linewidth]{%s}}\n', outputFilename);
    end
    
    clf; set(gcf,'color',[1,1,1]);
    isosurface(rotatedImplant(1:2:size(rotatedImplant,1),1:2:size(rotatedImplant,2),1:2:size(rotatedImplant,3)),0.5);
    isosurface(x3RegionOfInterest(1:2:size(x3RegionOfInterest,1),1:2:size(x3RegionOfInterest,2),1:2:size(x3RegionOfInterest,3)),0.5);
    axis equal tight
    convertUnit('xtick','xticklabel',2*MicroMeterPerPixel); xlabel('x/\mum');
    convertUnit('ytick','yticklabel',2*MicroMeterPerPixel); ylabel('y/\mum');
    convertUnit('ztick','zticklabel',2*MicroMeterPerPixel); zlabel('z/\mum');
    v = (marks(1,:)-marks(end,:))'; v = v/norm(v);
    %w = cross(rand(3,1)-0.5,v); w = w/norm(w);
    w = cross([.75,1,0]',v); w = w/norm(w);
    set(gca,'CameraUpVector',v)
    set(gca,'CameraTarget',origo/2)
    set(gca,'CameraPosition',marks(1,:)/2+2*size(newVol,1)*w'/2)
    set(gca,'FONTSIZE',SMALLFONTSIZE)
    set(gca,'Position', get(gca,'Position') - [0.05,0,0,0])
    delete(findall(gcf,'Type','light'))
    camlight('left')
    camlight('right')
    if(i==size(fractions,1))
        outputFilename = [figurePrefix,sprintf('%s_all.png','implantNfraction')];
    else
        outputFilename = [figurePrefix,sprintf('%s_%d.png','implantNfraction',i)];
    end
    if VERBOSE
        fprintf('  saving %s\n',outputFilename);
    end
    export_fig(outputFilename);
    if ~isempty(fid)
        fprintf(fid, '  \\subfigure{\\includegraphics[width=0.24\\linewidth]{%s}}\n', outputFilename);
    end
    
end
if ~isempty(fid)
    fprintf(fid, '  \\caption{%s}\n\\end{figure}\n', caption);
end
if PROGRESSOUTPUT
    fprintf('  %s file read and printed (%gs)\n',fractionsSuffix,toc);
    tic;
end
end