function maketex3d()

SMALLDATA = true;

% Visualization parameters
numberSlicesToShow = 3; % The number of exemplar slices generated

% Prefixes for the data files
annotationsPrefix = fullfile('.'); % Annotation file prefix (input)
if SMALLDATA
    analysisPrefix = fullfile('smallData'); % Analysis files prefix (input)
    pdfPrefix = fullfile('..', 'gedTex', 'figuresSmall'); % pdf filename prefix (output)
else
    analysisPrefix = fullfile('halfSizeData'); % Analysis files prefix (input)
    pdfPrefix = fullfile('..', 'gedTex', 'figuresMedium'); % pdf filename prefix (output)
end
latexFile = fullfile('..', 'gedTex', 'autoMain.tex'); % pdf filename prefix (output)

%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
fid = fopen(latexFile, 'wt');

load(fullfile(annotationsPrefix, 'annotations.mat')); % load p
names = fieldnames(p);
missingFiles = cell(0);
for j = 1:length(names)
    pJ = p.(names{j});
    % [fp, fn, fe] = fileparts(pJ.inputFilename);
    filePath = cell2mat(regexp(pJ.inputFilename, '(smallData.+)$', 'match'));
    [fp, fn, fe] = fileparts(filePath);
    % Escape underscores in filename, so that it may be used in a LaTeX caption
    fnEsc = strrep(fn, '_', '\_');
    
    newVolSize = whos('-file', filePath); newVolSize = newVolSize.size;
    slices = round(linspace(1, newVolSize(3), numberSlicesToShow+2));
    slices = slices(2:end-1);

    fprintf(fid, '\\section{%s}\n',fnEsc);
    fprintf(fid, '\\begin{figure}[H]\n  \\centering\n');
    for i = slices
        prefix = fullfile(pdfPrefix, sprintf('%s_%s_%d', fn, 'original_slice', i));
        missingFiles = printSubFigure(fid,prefix, '.pdf', 0.3, '', missingFiles);
    end
    for i = slices
        prefix = fullfile(pdfPrefix, sprintf('%s_%s_%d', fn, 'bias_corrected_slice', i));
        missingFiles = printSubFigure(fid,prefix, '.pdf', 0.3, '', missingFiles);
    end
    fprintf(fid, '\n');
%{
    for i = slices
        prefix = fullfile(pdfPrefix, sprintf('%s_%s_%d', fn, 'mask_slice', i));
        missingFiles = printSubFigure(fid,prefix, '.pdf', 0.3, '', missingFiles);
    end
%}
    fprintf(fid, '\n');
    for i = slices
        prefix = fullfile(pdfPrefix, sprintf('%s_%s_%d', fn, 'bone_slice', i));
        missingFiles = printSubFigure(fid,prefix, '.pdf', 0.3, '', missingFiles);
    end
    fprintf(fid, '\n');
    for i = slices
        prefix = fullfile(pdfPrefix, sprintf('%s_%s_%d', fn, 'cavities_slice', i));
        missingFiles = printSubFigure(fid,prefix, '.pdf', 0.3, '', missingFiles);
    end
    fprintf(fid, '  \\caption{%s: Segments. Columns from left to right are slices %d, %d, and %d. Rows are original image, smoothed, bias corrected and cropped image, segmented bone, and segmented cavity.}\n  \\label{fig:%sSegments}\n\\end{figure}\n', fnEsc, slices(1), slices(2), slices(3), fn);
    
    fprintf(fid, '\\begin{figure}[H]\n  \\centering\n');
    prefix = fullfile(pdfPrefix, sprintf('%s_%s', fn, 'implant'));
    missingFiles = printSubFigure(fid,prefix, '.png', 0.3, '', missingFiles);
    prefix = fullfile(pdfPrefix, sprintf('%s_%s_rotated', fn, 'zones'));
    missingFiles = printSubFigure(fid,prefix, '.pdf', 0.3, '', missingFiles);
    fprintf(fid, '  \\\\');
    for i = 1:2
    prefix = fullfile(pdfPrefix, sprintf('%s_%sNfraction_%d', fn, 'implant',i));
    missingFiles = printSubFigure(fid,prefix, '.png', 0.3, '', missingFiles);
    end
    prefix = fullfile(pdfPrefix, sprintf('%s_%sNfraction_all', fn, 'implant'));
    missingFiles = printSubFigure(fid,prefix, '.png', 0.3, '', missingFiles);
    fprintf(fid, '  \\caption{%s: Implant and zones.}\n  \\label{fig:%sZones}\n\\end{figure}\n', fnEsc, fn);
    
    fprintf(fid, '\\begin{figure}[H]\n  \\centering\n');
    for i = 1:2
        prefix = fullfile(pdfPrefix, sprintf('%s_%s_%d', fn, 'bone_fraction', i));
        missingFiles = printSubFigure(fid,prefix, '.pdf', 0.3, sprintf('zone %d',i), missingFiles);
    end
    prefix = fullfile(pdfPrefix, sprintf('%s_%s_all', fn, 'bone_fraction'));
    missingFiles = printSubFigure(fid,prefix, '.pdf', 0.3, 'All zones', missingFiles);
    for i = 1:2
        prefix = fullfile(pdfPrefix, sprintf('%s_%s_%d', fn, 'cavity_fraction', i));
        missingFiles = printSubFigure(fid,prefix, '.pdf', 0.3, sprintf('zone %d',i), missingFiles);
    end
    prefix = fullfile(pdfPrefix, sprintf('%s_%s_all', fn, 'cavity_fraction'));
    missingFiles = printSubFigure(fid,prefix, '.pdf', 0.3, 'All zones', missingFiles);
    fprintf(fid, '  \\caption{%s. Rows are bone and cavity fractions. Columns are zone 1, 2, and all.}\n  \\label{fig:%sFractions}\n\\end{figure}\n', fnEsc, fn);

    fprintf(fid, '\\begin{figure}[H]\n  \\centering\n');
    prefix = fullfile(pdfPrefix, sprintf('%s_%s', fn, 'edge_effect_bone'));
    missingFiles = printSubFigure(fid,prefix, '.pdf', 0.3, '', missingFiles);
    fprintf(fid, '  \\caption{%s: Edge effect.}\n  \\label{fig:%sEdgeEffect}\n\\end{figure}\n', fnEsc, fn);
    
    fprintf(fid, '\\clearpage\n');
end
if length(missingFiles) > 0
    disp('The following files are missing:')
    cellfun(@disp, missingFiles)
else
    disp('All referenced imagefiles exists')
end
fclose(fid);
end

function missingFiles = printSubFigure(fid,prefix, suffix, width, caption, missingFiles)
if exist([prefix suffix], 'file') == 0
    warning('Filename "%s%s" does not exist!', prefix,suffix)
    missingFiles{length(missingFiles)+1} = [prefix, suffix];
else
    if ~isempty(caption)
        caption = ['[', caption, ']'];
    end
    fprintf(fid, '  \\subfigure%s{\\includegraphics[width=%s\\linewidth]{%s}}\n', caption, num2str(width), prefix);
end
end