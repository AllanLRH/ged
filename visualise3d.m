function visualise3d(setup, masksSuffix, segmentsSuffix, edgeEffectSuffix, fractionsSuffix, numberSlicesToShow, fid, FONTSIZE, SMALLFONTSIZE, MARKERSIZE, LINEWIDTH, VERBOSE)
  %
  
  % Prefixes for the data files
  scaleFactor = setup.scaleFactor;
  imageFilename = setup.imageFilename;
  inputFilenamePrefix = setup.inputFilenamePrefix;
  MicroMeterPerPixel = setup.MicroMeterPerPixel;
  figurePrefix = setup.figurePrefix;
  origo = single(setup.origo);
  R = single(setup.R);
  marks = setup.marks;
  % We increase the number of micro threads by 2 (20% higher)
  marks(3,3) = 1.2*(marks(3,3)-marks(3,2)) + marks(3,2);
  maxDistance = 1000;

  %-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
  set(0, 'DefaultAxesFontSize', FONTSIZE)
  set(0, 'defaultlinelinewidth', LINEWIDTH)
  set(0, 'DefaultLineMarkerSize', MARKERSIZE)
  
  tic;
  newVol = loadImage(imageFilename, VERBOSE);
  
  slices = round(linspace(1, size(newVol, 3), numberSlicesToShow+2));
  slices = slices(2:end-1);
  
  visualizeImageSections(newVol, slices, MicroMeterPerPixel, figurePrefix, fid, VERBOSE);
  
  marksToShow = [3, 2, 4]; %size(marks, 2)
  [mask, rotatedImplant, x1, x2, x3] = visualizeImplant(newVol, origo, R, marks, marksToShow, MicroMeterPerPixel, figurePrefix, inputFilenamePrefix, masksSuffix, scaleFactor, fid, FONTSIZE, SMALLFONTSIZE, VERBOSE);
  
  visualizeSegments(newVol, mask, MicroMeterPerPixel, slices, figurePrefix, inputFilenamePrefix, segmentsSuffix, fid, VERBOSE);
  
  %visualizeBands(MicroMeterPerPixel, figurePrefix, inputFilenamePrefix, edgeEffectSuffix, fid, VERBOSE);
  
  visualizeFractions(marks, rotatedImplant, x1, x2, x3, marksToShow, maxDistance, MicroMeterPerPixel, figurePrefix, inputFilenamePrefix, fractionsSuffix, fid, SMALLFONTSIZE, VERBOSE);
end

function newVol = loadImage(imageFilename, VERBOSE)
  %
  if VERBOSE
    fprintf('  loading %s\n', imageFilename);
  end
  newVol = []; % default, mock value. Will be overwritten by load
  load(imageFilename, 'newVol'); % loads newVol
  if VERBOSE
    fprintf('  image file read (%gs)\n', toc);
    tic;
  end
end

function visualizeImageSections(newVol, slices, MicroMeterPerPixel, figurePrefix, fid, VERBOSE)
  %
  
  openLatexFigure(fid)
  for i = slices
    clf;
    showSlice = i;
    x1 = 1:size(newVol,1);
    x2 = 1:size(newVol,2);
    x3 = showSlice;
    visualiseImage(newVol(:, :, showSlice), x1, x2, MicroMeterPerPixel, sprintf('X_3 = %d\\mum', x3*MicroMeterPerPixel), 'X_1', 'X_2');
    outputFilename = sprintf('%s%s_%d.pdf', figurePrefix, 'original_slice', showSlice);
    saveFigure(outputFilename, VERBOSE);
    addLatexSubfigure(fid, outputFilename, 0.3)
  end
  [~, fn, fe] = fileparts(figurePrefix);
  closeLatexFigure(fid, sprintf('%s: Original image sections.', escLatex([fn, fe])));
  if VERBOSE
    fprintf('  Original image sections printed (%gs)\n', toc);
    tic;
  end
end

function [mask, rotatedImplant, x1, x2, x3] = visualizeImplant(newVol, origo, R, marks, marksToShow, MicroMeterPerPixel, figurePrefix, inputFilenamePrefix, masksSuffix, scaleFactor, fid, FONTSIZE, SMALLFONTSIZE, VERBOSE)
  %
  inputFilename = [inputFilenamePrefix, masksSuffix];
  
  if VERBOSE
    fprintf('  loading %s\n', inputFilename);
  end
  implant = []; % default, mock value. Will be overwritten by load
  mask = []; % default, mock value. Will be overwritten by load
  load(inputFilename, 'implant', 'mask');
  
  openLatexFigure(fid)
  
  xMax = round(size(newVol)/2);
  x1 = single(-xMax(1):xMax(1)); % x = c*(i-1)-xMax; i = (x+xMax)/c+1
  x2 = single(-xMax(2):xMax(2));
  x3 = single(-xMax(3):xMax(3));
  % Note: To get the original marks xMark do:
  %  x = (bsxfun(@plus,R*marks,origo));
  % To get the original marks on the isosurface do:
  %  xx = R'*bsxfun(@plus,x,-origo);
  rotatedImplant = sample3d(single(implant), origo, R, x1, x2, x3)>.5;
  
  clf;
  visualiseIsosurface(rotatedImplant, x1, x2, x3, 0.5, 2, MicroMeterPerPixel, 'x_1', 'x_2', 'x_3', [0,0,1], [0,0,0], xMax, SMALLFONTSIZE)
  outputFilename = [figurePrefix, sprintf('%s.png', 'implant')];
  saveFigure(outputFilename, VERBOSE, '-m2');
  addLatexSubfigure(fid, outputFilename, 0.3);
  
  set(gca, 'CameraPosition', [-xMax(1),-xMax(2),xMax(3)])
  camlight;
  outputFilename = [figurePrefix, sprintf('%s_altView.png', 'implant')];
  saveFigure(outputFilename, VERBOSE, '-m2');
  addLatexSubfigure(fid, outputFilename, 0.3);
  
  [~, fn, fe] = fileparts(figurePrefix);
  closeLatexFigure(fid, sprintf('%s: Implant from 2 different viewing directions.', escLatex([fn, fe])));
  
  openLatexFigure(fid)
  
  xSlice = single(0);
  slice = squeeze(sample3d(newVol, origo, R, xSlice, x2, x3));
  visualiseImage(slice, x2, x3, MicroMeterPerPixel, sprintf('x_1 = %d\\mum', xSlice*MicroMeterPerPixel), 'x_2', 'x_3');
  hold on;
  for i = 1:length(marksToShow)
    ii = marks(3,marksToShow(i));
    addPlotToImage([min(x2),max(x2)], ii * ones(i, 2), 'r-');
    if (i < size(marks, 1))
      addTextToImage(max(x2)-10, ii - scaleFactor*FONTSIZE, sprintf('Zone %d ', i), 'FontSize', FONTSIZE, 'Color', 'r', 'Rotation', 90);
    end
    %plot(ii * ones(i, 2), [min(x2),max(x2)], 'r-');
    %if (i < size(marks, 1))
    %  text(ii - FONTSIZE, max(x2)-10, sprintf('Zone %d ', i), 'FontSize', FONTSIZE, 'Color', 'r', 'Rotation', 90)
    %end
  end
  hold off
  outputFilename = [figurePrefix, sprintf('%s.pdf', 'zones')];
  saveFigure(outputFilename, VERBOSE)
  addLatexSubfigure(fid, outputFilename, 0.3)
  
  visualiseImage(slice, x2, x3, MicroMeterPerPixel, sprintf('x_1 = %d\\mum', xSlice*MicroMeterPerPixel), 'x_2', 'x_3');
  view(-90, 90);
  hold on;
  for i = 1:size(marks, 1)
    ii = marks(3,marksToShow(i));
    addPlotToImage([min(x2),max(x2)], ii * ones(i, 2), 'r-');
    if (i < size(marks, 1))
      addTextToImage(max(x2), ii - scaleFactor*FONTSIZE, sprintf('Zone %d ', i), 'FontSize', FONTSIZE, 'Color', 'r', 'HorizontalAlignment', 'right');
    end
    
    %plot(ii * ones(i, 2), [min(x2),max(x2)], 'r-');
    %if (i < size(marks, 1))
    %  text(ii - FONTSIZE, max(x2), sprintf('Zone %d ', i), 'FontSize', FONTSIZE, 'Color', 'r', 'HorizontalAlignment', 'right')
    %end
  end
  hold off
  outputFilename = [figurePrefix, sprintf('%s_rotated.pdf', 'zones')];
  saveFigure(outputFilename, VERBOSE)
  addLatexSubfigure(fid, outputFilename, 0.6)
  
  [~, fn, fe] = fileparts(figurePrefix);
  closeLatexFigure(fid, sprintf('%s: Zones in 2 different versions (same content).', escLatex([fn, fe])));
  
  openLatexFigure(fid)
  
  for i = 1:length(marksToShow)-1 %size(marks, 1)-1
    xSlice = single(round((marks(3, marksToShow(i))+marks(3, marksToShow(i+1)))/2));
    slice = squeeze(sample3d(newVol.*mask, origo, R, x1, x2, xSlice));
    slice(isnan(slice))=0;
    visualiseImage(slice, x1, x2, MicroMeterPerPixel, sprintf('x_3 = %d\\mum', xSlice*MicroMeterPerPixel), 'x_1', 'x_2');
    outputFilename = [figurePrefix, sprintf('%s%d_%s.pdf', 'zone', i, 'example')];
    saveFigure(outputFilename, VERBOSE)
    addLatexSubfigure(fid, outputFilename, 0.3)
  end
  
  [~, fn, fe] = fileparts(figurePrefix);
  closeLatexFigure(fid, sprintf('%s: Mid-zone image samples.', escLatex([fn, fe])));

  if VERBOSE
    fprintf('  %s file read and printed (%gs)\n', masksSuffix, toc);
    tic;
  end
end

function visualizeSegments(newVol, mask, MicroMeterPerPixel, slices, figurePrefix, inputFilenamePrefix, segmentsSuffix, fid, VERBOSE)
  %
  inputFilename = [inputFilenamePrefix, segmentsSuffix];
  
  if VERBOSE
    fprintf('  loading %s\n', inputFilename);
  end
  meanImg = []; % default, mock value. Will be overwritten by load
  boneMask = []; % default, mock value. Will be overwritten by load
  cavityMask = []; % default, mock value. Will be overwritten by load
  neitherMask = []; % default, mock value. Will be overwritten by load
  load(inputFilename, 'meanImg', 'boneMask', 'cavityMask', 'neitherMask');
  
  openLatexFigure(fid)
  
  for i = slices
    clf;
    showSlice = i;
    xMax = round(size(newVol)/2);
    x1 = -xMax(1):xMax(1);
    x2 = -xMax(2):xMax(2);
    x3 = -xMax(3):xMax(3);
    xSlice = x3(showSlice);
    
    visualiseImage(meanImg(:, :, showSlice), x1, x2, MicroMeterPerPixel, sprintf('x_3 = %d\\mum', xSlice*MicroMeterPerPixel), 'x_1', 'x_2');
    outputFilename = sprintf('%s%s_%d.pdf', figurePrefix, 'bias_corrected_slice', showSlice);
    saveFigure(outputFilename, VERBOSE);
    addLatexSubfigure(fid, outputFilename, 0.24);
    
    visualiseImage(mask(:, :, showSlice), x1, x2, MicroMeterPerPixel, sprintf('x_3 = %d\\mum', xSlice*MicroMeterPerPixel), 'x_1', 'x_2');
    outputFilename = sprintf('%s%s_%d.pdf', figurePrefix, 'mask_slice', showSlice);
    saveFigure(outputFilename, VERBOSE);
    addLatexSubfigure(fid, outputFilename, 0.24);
    
    visualiseImage(boneMask(:, :, showSlice), x1, x2, MicroMeterPerPixel, sprintf('x_3 = %d\\mum', xSlice*MicroMeterPerPixel), 'x_1', 'x_2');
    outputFilename = sprintf('%s%s_%d.pdf', figurePrefix, 'bone_slice', showSlice);
    saveFigure(outputFilename, VERBOSE);
    addLatexSubfigure(fid, outputFilename, 0.24);
    
    visualiseImage(cavityMask(:, :, showSlice), x1, x2, MicroMeterPerPixel, sprintf('x_3 = %d\\mum', xSlice*MicroMeterPerPixel), 'x_1', 'x_2');
    outputFilename = sprintf('%s%s_%d.pdf', figurePrefix, 'cavities_slice', showSlice);
    saveFigure(outputFilename, VERBOSE);
    addLatexSubfigure(fid, outputFilename, 0.24);
    
    visualiseImage(neitherMask(:, :, showSlice), x1, x2, MicroMeterPerPixel, sprintf('x_3 = %d\\mum', xSlice*MicroMeterPerPixel), 'x_1', 'x_2');
    outputFilename = sprintf('%s%s_%d.pdf', figurePrefix, 'neither_slice', showSlice);
    saveFigure(outputFilename, VERBOSE);
    %addLatexSubfigure(fid, outputFilename, 0.24);
  end
  
  [~, fn, fe] = fileparts(figurePrefix);
  closeLatexFigure(fid, sprintf('%s: Segments. Columns are: meanImage, mask, bone, cavity.', escLatex([fn, fe])));

  if VERBOSE
    fprintf('  %s file read and printed (%gs)\n', segmentsSuffix, toc);
    tic;
  end
  
end

function visualizeBands(MicroMeterPerPixel, figurePrefix, inputFilenamePrefix, edgeEffectSuffix, fid, VERBOSE)
  %
  inputFilename = [inputFilenamePrefix, edgeEffectSuffix];
  
  if VERBOSE
    fprintf('  loading %s\n', inputFilename);
  end
  bands = []; % default, mock value. Will be overwritten by load
  sumImgByBandsFromBone = []; % default, mock value. Will be overwritten by load
  sumImgByBandsFromCavity = []; % default, mock value. Will be overwritten by load
  load(inputFilename, 'bands', 'sumImgByBandsFromBone', 'sumImgByBandsFromCavity');
  
  openLatexFigure(fid)
  
  clf;
  b = MicroMeterPerPixel*linspace(min(bands), max(bands), 100);
  plot(b, interp1(bands, sumImgByBandsFromBone, b, 'pchip')); axis tight;
  xlabel('distance/\mum');
  ylabel('normalized intensity');
  outputFilename = [figurePrefix, sprintf('%s.pdf', 'edge_effect_bone')];
  saveFigure(outputFilename, VERBOSE)
  addLatexSubfigure(fid, outputFilename, 0.3)
  
  plot(b, interp1(bands, sumImgByBandsFromCavity, b, 'pchip')); axis tight;
  xlabel('distance/\mum');
  ylabel('normalized intensity');
  outputFilename = [figurePrefix, sprintf('%s.pdf', 'edge_effect_cavity')];
  saveFigure(outputFilename, VERBOSE)
  addLatexSubfigure(fid, outputFilename, 0.3)
  
  [~, fn, fe] = fileparts(figurePrefix);
  closeLatexFigure(fid, sprintf('%s: Overshooting effect.', escLatex([fn, fe])));

  if VERBOSE
    fprintf('  %s file read and printed (%gs)\n', edgeEffectSuffix, toc);
    tic;
  end
end

function visualizeFractions(marks, rotatedImplant, rix1, rix2, rix3, marksToShow, maxDistance, MicroMeterPerPixel, figurePrefix, inputFilenamePrefix, fractionsSuffix, fid, SMALLFONTSIZE, VERBOSE)
  %
  inputFilename = [inputFilenamePrefix, fractionsSuffix];
  
  if VERBOSE
    fprintf('  loading %s\n', inputFilename);
  end
  x1 = []; % default, mock value. Will be overwritten by load
  x2 = []; % default, mock value. Will be overwritten by load
  x3 = []; % default, mock value. Will be overwritten by load
  bone = []; % default, mock value. Will be overwritten by load
  cavity = []; % default, mock value. Will be overwritten by load
  neither = []; % default, mock value. Will be overwritten by load
  distances = []; % default, mock value. Will be overwritten by load
  load(inputFilename, 'x1', 'x2', 'x3', 'bone', 'cavity', 'neither', 'distances');
  
  openLatexFigure(fid)
  
  [fp, fn, ~] = fileparts(fractionsSuffix);
  csvSuffix = fullfile(fp,[fn,'.csv']);
  csvwrite([figurePrefix, 'x1_', csvSuffix], x1*MicroMeterPerPixel);
  csvwrite([figurePrefix, 'x2_', csvSuffix], x2*MicroMeterPerPixel);
  csvwrite([figurePrefix, 'x3_', csvSuffix], x3*MicroMeterPerPixel);
  csvwrite([figurePrefix, 'distances_', csvSuffix], distances*MicroMeterPerPixel);
  csvwrite([figurePrefix, 'bone_', csvSuffix], bone);
  csvwrite([figurePrefix, 'cavity_', csvSuffix], cavity);
  csvwrite([figurePrefix, 'neither_', csvSuffix], neither);
  
  distances = distances*MicroMeterPerPixel;
  % distances are right values of interval. We reset it to middle of
  % interval, assuming the first is from zero
  distances = ([0, distances(1:end-1)]+distances)/2;
  
  distanceMaxInd = find(distances<maxDistance);
  distanceMaxInd = distanceMaxInd(end);
  
  for i = 1:length(marksToShow)
    if i == length(marksToShow)
      % We use last i-value as a marker to indicate all.
      x3From = min(marks(3, marksToShow(:)));
      x3To = max(marks(3, marksToShow(:)));
    else
      x3From = marks(3, marksToShow(i));
      x3To = marks(3, marksToShow(i+1));
    end
    [~,ii1] = min((x3 - x3From).^2);
    [~,ii2] = min((x3 - x3To).^2);
    if ii1 > ii2
      tmp = ii2;
      ii2 = ii1;
      ii1 = tmp;
    end;
    x3From = x3From*MicroMeterPerPixel;
    x3To = x3To*MicroMeterPerPixel;
    
    clf;
    %x3RegionOfInterest = fractions{i}{1};
    %minSlice = round(fractions{i}{2});
    %maxSlice = round(fractions{i}{3});
    boneFraction = bone(ii2,:)-bone(ii1,:);
    cavityFraction = cavity(ii2,:)-cavity(ii1,:);
    neitherFraction = neither(ii2,:)-neither(ii1,:);

    csvwrite([figurePrefix, sprintf('%s_%d.csv', 'bone_sum', i)], boneFraction);
    csvwrite([figurePrefix, sprintf('%s_%d.csv', 'cavity_sum', i)], cavityFraction);
    csvwrite([figurePrefix, sprintf('%s_%d.csv', 'neither_sum', i)], neitherFraction);
    
    boneFraction = [0,boneFraction(1:end-1)]-boneFraction;
    cavityFraction = [0,cavityFraction(1:end-1)]-cavityFraction;
    neitherFraction = [0,neitherFraction(1:end-1)]-neitherFraction;
    
    total = boneFraction + cavityFraction + neitherFraction;
    boneFraction = boneFraction ./ total;
    cavityFraction = cavityFraction ./ total;
    neitherFraction = neitherFraction ./ total;
    
    plot(distances(1:distanceMaxInd), boneFraction(1:distanceMaxInd));
    ylim([0, 1]);
    xlabel('distance/\mum');
    ylabel('fraction');
    title(sprintf('Bone: from %g%s to %g%s', x3From, '\mum', x3To, '\mum'));
    outputFilename = [figurePrefix, sprintf('%s_%d.pdf', 'bone_fraction', i)];
    saveFigure(outputFilename, VERBOSE)
    addLatexSubfigure(fid, outputFilename, 0.24)
    
    plot(distances(1:distanceMaxInd), cavityFraction(1:distanceMaxInd));
    ylim([0, 1]);
    xlabel('distance/\mum');
    ylabel('fraction');
    title(sprintf('Cavity: from %g%s to %g%s', x3From, '\mum', x3To, '\mum'));
    outputFilename = [figurePrefix, sprintf('%s_%d.pdf', 'cavity_fraction', i)];
    saveFigure(outputFilename, VERBOSE)
    addLatexSubfigure(fid, outputFilename, 0.24)
    
    plot(distances(1:distanceMaxInd), neitherFraction(1:distanceMaxInd));
    ylim([0, 1]);
    xlabel('distance/\mum');
    ylabel('fraction');
    title(sprintf('Neither: from %g%s to %g%s', x3From, '\mum', x3To, '\mum'));
    outputFilename = [figurePrefix, sprintf('%s_%d.pdf', 'neither_fraction', i)];
    saveFigure(outputFilename, VERBOSE)
    addLatexSubfigure(fid, outputFilename, 0.24)
    
    xMax = [max(rix1),max(rix2),max(rix3)];
    clf;
    visualiseIsosurface(rotatedImplant, rix1, rix2, rix3, 0.5, 2, MicroMeterPerPixel, 'x_1', 'x_2', 'x_3', [0,0,1], [0,0,0], xMax, SMALLFONTSIZE)
    x3RegionOfInterest = zeros(size(rotatedImplant));
    x3RegionOfInterest(:,:,ii1:ii2) = 1;
    visualizeAdditionalIsosurface(x3RegionOfInterest, x1, x2, x3, 0.5, 2);
    outputFilename = [figurePrefix, sprintf('%s_%d.png', 'implantNfraction', i)];
    saveFigure(outputFilename, VERBOSE)
    addLatexSubfigure(fid, outputFilename, 0.24)
  end
  
  [~, fn, fe] = fileparts(figurePrefix);
  closeLatexFigure(fid, sprintf('%s: Fractions. Rows are zone 1, zone 2, and both zones. Columns are bone-, cavity-, and neither-fraction graphs.', escLatex([fn, fe])));

  if VERBOSE
    fprintf('  %s file read and printed (%gs)\n', fractionsSuffix, toc);
    tic;
  end
end

function visualiseImage(I, x1, x2, MicroMeterPerPixel, figureTitle, x1label, x2label)
  imagesc(I,'XData',x2,'YData',x1); colormap(gray); axis image tight;
  convertUnit('xtick', 'xticklabel', MicroMeterPerPixel);
  xlabel([x2label, '/\mum']);
  convertUnit('ytick', 'yticklabel', MicroMeterPerPixel);
  ylabel([x1label,'/\mum']);
  title(figureTitle);
end

function addPlotToImage(x1, x2, varargin)
  plot(double(x2), double(x1), varargin{:});
end

function addTextToImage(x1, x2, varargin)
  text(double(x2), double(x1), varargin{:})
end

function visualiseIsosurface(I, x1, x2, x3, v, reduceFactor, MicroMeterPerPixel, x1label, x2label, x3label, cameraUp, cameraTarget, cameraPosition, FONTSIZE)

  %isosurface(permute(x2,[2,1,3]), permute(x1,[2,1,3]), permute(x3,[2,1,3]), I, v);
  [nx,ny,nz,nI] = reducevolume(permute(x2,[2,1,3]),permute(x1,[2,1,3]),permute(x3,[2,1,3]),I,reduceFactor);
  isosurface(nx, ny, nz, nI, v);
  set(gca, 'CameraUpVector', cameraUp)
  set(gca, 'CameraTarget', cameraTarget)
  set(gca, 'CameraPosition', cameraPosition)
  axis equal tight
  convertUnit('xtick', 'xticklabel', MicroMeterPerPixel); xlabel([x2label, '/\mum']);
  convertUnit('ytick', 'yticklabel', MicroMeterPerPixel); ylabel([x1label, '/\mum']);
  convertUnit('ztick', 'zticklabel', MicroMeterPerPixel); zlabel([x3label, '/\mum']);
  set(gca, 'FONTSIZE', FONTSIZE)
  %  set(gca, 'Position', get(gca, 'Position') + [0.15, 0, 0, 0])
  delete(findall(gcf, 'Type', 'light'))
  camlight;
end

function visualizeAdditionalIsosurface(I, x1, x2, x3, v, reduceFactor)
  %isosurface(permute(x2,[2,1,3]),permute(x1,[2,1,3]),permute(x3,[2,1,3]), I, v);
  [nx,ny,nz,nI] = reducevolume(permute(x2,[2,1,3]),permute(x1,[2,1,3]),permute(x3,[2,1,3]),I,reduceFactor);
  isosurface(nx, ny, nz, nI, v);
end

function saveFigure(outputFilename, VERBOSE, varargin)
  if VERBOSE
    fprintf('  saving %s\n', outputFilename);
  end
  
  set(gcf, 'color', [1, 1, 1]);
  if isempty(varargin)
    export_fig(outputFilename);
  else
    export_fig(outputFilename, varargin);
  end
end

function fnEsc = escLatex(str)
  fnEsc = strrep(str, '_', '\_'); % Prefix has no suffix
end

function openLatexFigure(fid)
  if fid ~= -1
    fprintf(fid, '\\begin{figure}[ht]\n  \\centering\n');
  end
end

function closeLatexFigure(fid, caption)
  if fid ~= -1
    fprintf(fid, '  \\caption{%s}\n\\end{figure}\n', caption);
  end
end

function addLatexSubfigure(fid, outputFilename, varargin)
  if fid ~= -1
    width = [];
    caption = [];
    if ~isempty(varargin)
      width = varargin{1};
    end
    if length(varargin) > 1
      caption = varargin{2};
    end
    fprintf(fid, '  \\subfigure');
    if ~isempty(caption)
      fprintf(fid, '  [%s]', caption);
    end
    fprintf(fid, '  {\\includegraphics');
    if ~isempty(width)
      fprintf(fid, '[width=%.3f\\linewidth]', width);
    end
    fprintf(fid, '{%s}}\n', outputFilename);
  end
end
