SMALLDATA = true;

% Visualization parameters
numberSlicesToShow = 3; % The number of exemplar slices generated

% Prefixes for the data files
annotationsPrefix = fullfile('~','AKIRA','ged'); % Annotation file prefix (input)
if SMALLDATA
    analysisPrefix = fullfile('~','AKIRA','ged','smallData'); % Analysis files prefix (input)
    pdfPrefix = fullfile('~','AKIRA','gedTex','figuresSmall'); % pdf filename prefix (output)
else
    analysisPrefix = fullfile('~','AKIRA','ged','halfSizeData'); % Analysis files prefix (input)
    pdfPrefix = fullfile('~','AKIRA','gedTex','figuresMedium'); % pdf filename prefix (output)
end
latexFile = fullfile('~','AKIRA','gedTex','autoMain.tex'); % pdf filename prefix (output)

%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
fid = fopen(latexFile, 'wt');

load(fullfile(annotationsPrefix,'annotations.mat')); % load p
names = fieldnames(p);
for j = 1:2%length(names)
    pJ = p.(names{j});
    [fp, fn, fe] = fileparts(pJ.inputFilename);
    
    slices = round(linspace(1,size(newVol,3),numberSlicesToShow+2));
    slices = slices(2:end-1);
    fprintf(fid, '\\\begin{figure}\n\\centering\n');
    for i = slices
        fprintf(fid, '\\subfigure[z=%d voxels]{\\includegraphics[width=0.3\\linewidth]{%s}}\n',i,fullfile(pdfPrefix,sprintf('%s_%s_%d',fn,'original_slice',i)));
    end
    fprintf(fid, '\\caption{%s: Original image sections.}\n\\label{fig:%s}\n\\end{figure}\n',fn,fn);
    
    fprintf(fid, '\\begin{figure}\n\\centering\n');
    fprintf(fid, '\\subfigure{\\includegraphics[width=0.3\\linewidth]{%s}}\n',fullfile(pdfPrefix,sprintf('%s_%s',fn,'implant')));
    fprintf(fid, '\\subfigure{\\includegraphics[width=0.3\\linewidth]{%s}}\n',fullfile(pdfPrefix,sprintf('%s_%s',fn,'zones')));
    fprintf(fid, '\\caption{%s: Implant and zones.}\n\\label{fig:%s}\n\\end{figure}\n',fn,fn);

    fprintf(fid, '\\begin{figure}\n\\centering\n');
    for i = slices
        fprintf(fid, ['\\subfigure{\\includegraphics[width=0.3\\linewidth]{%s}}\n'],fullfile(pdfPrefix,sprintf('%s_%s_%d',fn,'bias_corrected_slice',showSlice)));
    end        
    fprintf(fid,'\n');
    for i = slices
        fprintf(fid, ['\\subfigure{\\includegraphics[width=0.3\\linewidth]{%s}}\n'],fullfile(pdfPrefix,sprintf('%s_%s_%d',fn,'mask_slice',showSlice)));
    end        
    fprintf(fid,'\n');
    for i = slices
        fprintf(fid, ['\\subfigure{\\includegraphics[width=0.3\\linewidth]{%s}}\n'],fullfile(pdfPrefix,sprintf('%s_%s_%d',fn,'bone_slice',showSlice)));
    end        
    fprintf(fid,'\n');
    for i = slices
        fprintf(fid, ['\\subfigure{\\includegraphics[width=0.3\\linewidth]{%s}}\n'],fullfile(pdfPrefix,sprintf('%s_%s_%d',fn,'cavities_slice',showSlice)));
    end        
    fprintf(fid, ['\\caption{%s: Segments. Columns from left to right are slices %d, %d, and %d. Rows are original smoothed image, mask, segmented bone, and segmented cavity.}\n\\label{fig:%s}\n\\end{figure}\n'], fn,slice(1),slice(2),slice(3),fn);
    
    fprintf(fid, '\\begin{figure}\n\\centering\n');
    fprintf(fid, ['\\subfigure{\\includegraphics[width=0.3\\linewidth]{%s}}\n'],fullfile(pdfPrefix,sprintf('%s_%s.pdf',fn,'edge_effect_bone')));
    fprintf(fid, ['\\caption{%s: Edge effect.}\n\\label{fig:%s}\n\\end{figure}\n'], fn,fn);

    fprintf(fid, '\\begin{figure}\n\\centering\n');
    for i = 1:size(fractions,1)
        fprintf(fid, '\\subfigure[zone %d]{\\includegraphics[width=0.3\\linewidth]{%s}}\n',i,fullfile(pdfPrefix,sprintf('%s_%s_%d.pdf',fn,'bone_fraction',i)));
    end
    fprintf(fid, ['\\caption{%s: Bone fractions.}\n\\label{fig:%s}\n\\end{figure}\n'], fn,fn);
    fprintf(fid, '\\begin{figure}\n\\centering\n');
    fprintf(fid, ['\\subfigure{\\includegraphics[width=0.3\\linewidth]{%s}}\n'],fullfile(pdfPrefix,sprintf('%s_%s.pdf',fn,'edge_effect_bone')));
    fprintf(fid, ['\\caption{%s: Edge effect.}\n\\label{fig:%s}\n\\end{figure}\n'], fn,fn);

    fprintf(fid, '\\clearpage\n');
end
fclose(fid);