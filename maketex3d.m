% Prefixes for the data files
setup = setPrefixes3d();
annotationsPrefix = setup.annotationsPrefix;
inputPrefix = setup.inputPrefix;
analysisPrefix = setup.analysisPrefix;
figurePrefix = setup.figurePrefix;
scaleFactor = setup.scaleFactor;
MicroMeterPerPixel = setup.MicroMeterPerPixel;
numberSlicesToShow = setup.numberSlicesToShow;

latexFile = fullfile(latexPrefix, 'autoMain.tex'); % pdf filename prefix (output)

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
    fprintf(fid, '\\begin{figure}\n  \\centering\n');
    for i = slices
        % make filename path and check that the file exists
        filename = fullfile(figurePrefix, sprintf('%s_%s_%d', fn, 'original_slice', i));
        if exist([filename '.pdf'], 'file') == 0
            warning('Filename "%s.pdf" does not exist!', filename)
            missingFiles{length(missingFiles)+1} = [filename '.pdf'];
        end
        % Write the line to the tex file
        fprintf(fid, '  \\subfigure[z=%d voxels]{\\includegraphics[width=0.3\\linewidth]{%s}}\n', i, filename);
    end
    fprintf(fid, '  \\caption{%s: Original image sections.}  \n  \\label{fig:%s}\n\\end{figure}\n', fnEsc, fn);

    fprintf(fid, '\\begin{figure}\n  \\centering\n');
    % make filename path and check that the file exists
    filename = fullfile(figurePrefix, sprintf('%s_%s', fn, 'implant'));
    if exist([filename '.png'], 'file') == 0
        warning('Filename "%s.png" does not exist!', filename)
        missingFiles{length(missingFiles)+1} = [filename '.png'];
    end
    % Write the line to the tex file
    fprintf(fid, '  \\subfigure{\\includegraphics[width=0.3\\linewidth]{%s}}\n', filename);
    % make filename path and check that the file exists
    filename = fullfile(figurePrefix, sprintf('%s_%s', fn, 'zones'));
    if exist([filename '.pdf'], 'file') == 0
        warning('Filename "%s.pdf" does not exist!', filename)
        missingFiles{length(missingFiles)+1} = [filename '.pdf'];
    end
    % Write the line to the tex file
    fprintf(fid, '  \\subfigure{\\includegraphics[width=0.3\\linewidth]{%s}}\n', filename);
    fprintf(fid, '  \\caption{%s: Implant and zones.}\n  \\label{fig:%s}\n\\end{figure}\n', fnEsc, fn);

    fprintf(fid, '\\begin{figure}\n  \\centering\n');
    for i = slices
        % make filename path and check that the file exists
        filename = fullfile(figurePrefix, sprintf('%s_%s_%d', fn, 'bias_corrected_slice', i));
        if exist([filename '.pdf'], 'file') == 0
            warning('Filename "%s.pdf" does not exist!', filename)
            missingFiles{length(missingFiles)+1} = [filename '.pdf'];
        end
        % Write the line to the tex file
        fprintf(fid, '  \\subfigure{\\includegraphics[width=0.3\\linewidth]{%s}}\n', filename);
    end
    fprintf(fid, '\n');
    for i = slices
        % make filename path and check that the file exists
        filename = fullfile(figurePrefix, sprintf('%s_%s_%d', fn, 'mask_slice', i));
        if exist([filename '.pdf'], 'file') == 0
            warning('Filename "%s.pdf" does not exist!', filename)
            missingFiles{length(missingFiles)+1} = [filename '.pdf'];
        end
        % Write the line to the tex file
        fprintf(fid, '  \\subfigure{\\includegraphics[width=0.3\\linewidth]{%s}}\n', filename);
    end
    fprintf(fid, '\n');
    for i = slices
        % make filename path and check that the file exists
        filename = fullfile(figurePrefix, sprintf('%s_%s_%d', fn, 'bone_slice', i));
        if exist([filename '.pdf'], 'file') == 0
            warning('Filename "%s.pdf" does not exist!', filename)
            missingFiles{length(missingFiles)+1} = [filename '.pdf'];
        end
        % Write the line to the tex file
        fprintf(fid, '  \\subfigure{\\includegraphics[width=0.3\\linewidth]{%s}}\n', filename);
    end
    fprintf(fid, '\n');
    for i = slices
        % make filename path and check that the file exists
        filename = fullfile(figurePrefix, sprintf('%s_%s_%d', fn, 'cavities_slice', i));
        if exist([filename '.pdf'], 'file') == 0
            warning('Filename "%s.pdf" does not exist!', filename)
            missingFiles{length(missingFiles)+1} = [filename '.pdf'];
        end
        % Write the line to the tex file
        fprintf(fid, '  \\subfigure{\\includegraphics[width=0.3\\linewidth]{%s}}\n', filename);
    end
    fprintf(fid, '  \\caption{%s: Segments. Columns from left to right are slices %d, %d, and %d. Rows are original smoothed image, mask, segmented bone, and segmented cavity.}\n  \\label{fig:%s}\n\\end{figure}\n', fnEsc, slices(1), slices(2), slices(3), fn);

    fprintf(fid, '\\begin{figure}\n  \\centering\n');
    % make filename path and check that the file exists
    filename = fullfile(figurePrefix, sprintf('%s_%s.pdf', fn, 'edge_effect_bone'));
    if exist(filename, 'file') == 0
        warning('Filename "%s" does not exist!', filename)
        missingFiles{length(missingFiles)+1} = filename;
    end
    % Write the line to the tex file
    fprintf(fid, '  \\subfigure{\\includegraphics[width=0.3\\linewidth]{%s}}\n', filename);
    fprintf(fid, '  \\caption{%s: Edge effect.}\n  \\label{fig:%s}\n\\end{figure}\n', fnEsc, fn);

    fprintf(fid, '\\begin{figure}\n  \\centering\n');
    for i = 1:3
        % make filename path and check that the file exists
        filename = fullfile(figurePrefix, sprintf('%s_%s_%d', fn, 'bone_fraction', i));
        if exist([filename '.pdf'], 'file') == 0
            warning('Filename "%s.pdf" does not exist!', filename)
            missingFiles{length(missingFiles)+1} = [filename '.pdf'];
        end
        % Write the line to the tex file
        fprintf(fid, '  \\subfigure[zone %d]{\\includegraphics[width=0.3\\linewidth]{%s}}\n', i, filename);
    end
    fprintf(fid, '  \\caption{%s: Bone fractions.}\n  \\label{fig:%s}\n\\end{figure}\n', fnEsc, fn);
    fprintf(fid, '\\begin{figure}\n  \\centering\n');
    % make filename path and check that the file exists
    filename = fullfile(figurePrefix, sprintf('%s_%s', fn, 'edge_effect_bone'));
    if exist([filename '.pdf'], 'file') == 0
        warning('Filename "%s.pdf" does not exist!', filename)
        missingFiles{length(missingFiles)+1} = [filename '.pdf'];
    end
    % Write the line to the tex file
    fprintf(fid, '  \\subfigure{\\includegraphics[width=0.3\\linewidth]{%s}}\n', filename);
    fprintf(fid, '  \\caption{%s: Edge effect.}\n  \\label{fig:%s}\n\\end{figure}\n', fnEsc, fn);

    fprintf(fid, '\\clearpage\n');
end
if length(missingFiles) > 0
    disp('The following files are missing:')
    cellfun(@disp, missingFiles)
else
    disp('All referenced imagefiles exists')
end
fclose(fid);
