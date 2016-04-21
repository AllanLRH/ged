% Global plotting parameters
FONTSIZE = 18;
SMALLFONTSIZE = 12;
MARKERSIZE = 15;
LINEWIDTH=3;
PROGRESSOUTPUT=true;
SMALLDATA = true;

% Visualization parameters
numberSlicesToShow = 3; % The number of exemplar slices generated

% Prefixes for the data files
%annotationsPrefix = fullfile('~','AKIRA','ged'); % Annotation file prefix (input)
annotationsPrefix = fullfile('.'); % Annotation file prefix (input)
if SMALLDATA
    scaleFactor = 1; % scaling factor used in the analysis fase w.r.t. annotation file
    %    analysisPrefix = fullfile('~','AKIRA','ged','smallData'); % Analysis files prefix (input)
    %    pdfPrefix = fullfile('~','AKIRA','gedTex','figuresSmall'); % pdf filename prefix (output)
    analysisPrefix = fullfile('smallData'); % Analysis files prefix (input)
    pdfPrefix = fullfile('..','gedTex','figuresSmall'); % pdf filename prefix (output)
else
    scaleFactor = 2; % scaling factor used in the analysis fase w.r.t. annotation file
    %    analysisPrefix = fullfile('~','AKIRA','ged','halfSizeData'); % Analysis files prefix (input)
    %    pdfPrefix = fullfile('~','AKIRA','gedTex','figuresMedium'); % pdf filename prefix (output)
    analysisPrefix = fullfile('halfSizeData'); % Analysis files prefix (input)
    pdfPrefix = fullfile('..','gedTex','figuresMedium'); % pdf filename prefix (output)
end
MicroMeterPerPixel = 5*4/scaleFactor;

%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
set(0,'DefaultAxesFontSize',FONTSIZE)
set(0,'defaultlinelinewidth',LINEWIDTH)
set(0,'DefaultLineMarkerSize',15)

load(fullfile(annotationsPrefix,'annotations.mat')); % load p
names = fieldnames(p);
for j = 1:length(names)
    if PROGRESSOUTPUT
        fprintf('%d: %s\n',j,names{j})
        tic;
    end
    n = 0;
    pJ = scaleBoneFractionParameters(p.(names{j}), scaleFactor);
    [fp, fn, fe] = fileparts(pJ.inputFilename);
    % We may have moved stuff, so we override path
    load(fullfile(analysisPrefix,[fn,fe]));
    if PROGRESSOUTPUT
        fprintf('  annotation file read (%gs)\n',toc);
        tic;
    end
    
    slices = round(linspace(1,size(newVol,3),numberSlicesToShow+2));
    slices = slices(2:end-1);
    
    if ~exist(fullfile(analysisPrefix,[fn,'_params.mat']),'file')
        if PROGRESSOUTPUT
            fprintf('  file does not exist, moving on to next (%gs)\n',toc);
            tic;
        end
    else
        load(fullfile(analysisPrefix,[fn,'_params.mat']));%'inputFilename','aBoneExample','aCavityExample','anImplantExample','avoidEdgeDistance','avoidEdgeDistance','filterRadius','maxIter','maxDistance','origo','R','marks');
        for i = slices
            clf; set(gcf,'color',[1,1,1]);
            showSlice = i;
            imagesc(newVol(:,:,showSlice)); colormap(gray); axis image tight;
            convertUnit('xtick','xticklabel',MicroMeterPerPixel); xlabel('x/\mum');
            convertUnit('ytick','yticklabel',MicroMeterPerPixel); ylabel('y/\mum');
            export_fig(fullfile(pdfPrefix,sprintf('%s_%s_%d.pdf',fn,'original_slice',showSlice)));
        end
        if PROGRESSOUTPUT
            fprintf('  _params.mat file read and printed (%gs)\n',toc);
            tic;
        end
        
        load(fullfile(analysisPrefix,[fn,'_masks.mat']));%,'implant','circularRegionOfInterest','x3RegionOfInterest','mask');
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
        delete(findall(gcf,'Type','light'))
        camlight('left')
        camlight('right')
        export_fig(fullfile(pdfPrefix,sprintf('%s_%s.png',fn,'implant')),'-m2');
        if PROGRESSOUTPUT
            fprintf('  _masks file read and printed (%gs)\n',toc);
            tic;
        end

        for i = 1:size(pJ.marks,1)-1
            xMax = round(size(newVol)/2);
            x1 = -(xMax(1)-1):xMax(1);
            x2 = -(xMax(2)-1):xMax(2);
            x3 = -(xMax(3)-1):xMax(3);
            t = round((pJ.marks(i,3)+pJ.marks(i+1,3))/2);
            x3 = x3(t);
            %slice = squeeze(sample3d(newVol,pJ.origo,pJ.R,x1,x2,x3));
            slice = squeeze(sample3d(newVol.*mask,pJ.origo,pJ.R,x1,x2,x3));
            imagesc(slice); colormap(gray); axis image tight;
            convertUnit('xtick','xticklabel',MicroMeterPerPixel); xlabel('x/\mum');
            convertUnit('ytick','yticklabel',MicroMeterPerPixel); ylabel('y/\mum');
            title(sprintf('z = %d\\mum',t*MicroMeterPerPixel));
            %pause;
            export_fig(fullfile(pdfPrefix,sprintf('%s_%s%d_%s.pdf',fn,'zone',i,'example')));
        end

        xMax = round(size(newVol)/2);
        x1 = 0;
        x2 = -(xMax(2)-1):xMax(2);
        x3 = -(xMax(3)-1):xMax(3);
        textDir = sign(dot(pJ.marks(end,:)-pJ.marks(1,:),[0,0,1]));
        slice = squeeze(sample3d(newVol,pJ.origo,pJ.R,x1,x2,x3));
        imagesc(slice); colormap(gray); axis image tight;
        convertUnit('xtick','xticklabel',MicroMeterPerPixel); xlabel('z/\mum');
        convertUnit('ytick','yticklabel',MicroMeterPerPixel); ylabel('x/\mum');
        hold on;
        for i = 1:size(pJ.marks,1)
            plot(pJ.marks(i,3)*ones(i,2),[1,size(slice,1)],'r-');
            if (i < size(pJ.marks,1))
                text(pJ.marks(i,3)+textDir*2*FONTSIZE*2/3,1,sprintf('Zone %d ',i),'HorizontalAlignment','right','FontSize',FONTSIZE,'Color','r','Rotation',90)
            end
        end
        hold off
        export_fig(fullfile(pdfPrefix,sprintf('%s_%s.pdf',fn,'zones')));
        imagesc(fliplr(slice')); colormap(gray); axis image tight;
        convertUnit('xtick','xticklabel',MicroMeterPerPixel); xlabel('x/\mum');
        convertUnit('ytick','yticklabel',MicroMeterPerPixel); ylabel('z/\mum');
        hold on;
        for i = 1:size(pJ.marks,1)
            plot([1,size(slice,1)],pJ.marks(i,3)*ones(i,2),'r-');
            if (i < size(pJ.marks,1))
                text(10,pJ.marks(i,3)+textDir*2*FONTSIZE*2/3,sprintf('Zone %d ',i),'FontSize',FONTSIZE,'Color','r')
            end
        end
        hold off
        export_fig(fullfile(pdfPrefix,sprintf('%s_%s_rotated.pdf',fn,'zones')));
        if PROGRESSOUTPUT
            fprintf('  zones printed (%gs)\n',toc);
            tic;
        end
        
        load(fullfile(analysisPrefix,[fn,'_segments.mat']));%,'meanImg','boneMask','cavityMask','neitherMask');
        for i = slices
            clf; set(gcf,'color',[1,1,1]);
            showSlice = i;
            imagesc(meanImg(:,:,showSlice)); colormap(gray); axis image tight;
            convertUnit('xtick','xticklabel',MicroMeterPerPixel); xlabel('x/\mum');
            convertUnit('ytick','yticklabel',MicroMeterPerPixel); ylabel('y/\mum');
            export_fig(fullfile(pdfPrefix,sprintf('%s_%s_%d.pdf',fn,'bias_corrected_slice',showSlice)));
            imagesc(mask(:,:,showSlice)); colormap(gray); axis image tight;
            convertUnit('xtick','xticklabel',MicroMeterPerPixel); xlabel('x/\mum');
            convertUnit('ytick','yticklabel',MicroMeterPerPixel); ylabel('y/\mum');
            export_fig(fullfile(pdfPrefix,sprintf('%s_%s_%d.pdf',fn,'mask_slice',showSlice)));
            imagesc(cavityMask(:,:,showSlice)); colormap(gray); axis image tight;
            convertUnit('xtick','xticklabel',MicroMeterPerPixel); xlabel('x/\mum');
            convertUnit('ytick','yticklabel',MicroMeterPerPixel); ylabel('y/\mum');
            export_fig(fullfile(pdfPrefix,sprintf('%s_%s_%d.pdf',fn,'cavities_slice',showSlice)));
            imagesc(boneMask(:,:,showSlice)); colormap(gray); axis image tight;
            convertUnit('xtick','xticklabel',MicroMeterPerPixel); xlabel('x/\mum');
            convertUnit('ytick','yticklabel',MicroMeterPerPixel); ylabel('y/\mum');
            export_fig(fullfile(pdfPrefix,sprintf('%s_%s_%d.pdf',fn,'bone_slice',showSlice)));
            imagesc(neitherMask(:,:,showSlice).*meanImg(:,:,showSlice)); colormap(gray); axis image tight;
            convertUnit('xtick','xticklabel',MicroMeterPerPixel); xlabel('x/\mum');
            convertUnit('ytick','yticklabel',MicroMeterPerPixel); ylabel('y/\mum');
            export_fig(fullfile(pdfPrefix,sprintf('%s_%s_%d.pdf',fn,'neither_slice',showSlice)));
            hist(meanImg(neitherMask(:,:,showSlice)),1000); axis tight;
            xlabel('normalised intensity');
            ylabel('frequency');
            export_fig(fullfile(pdfPrefix,sprintf('%s_%s_%d.pdf',fn,'neither_histogram_slice',showSlice)));
        end
        if PROGRESSOUTPUT
            fprintf('  _segments.mat file read and printed (%gs)\n',toc);
            tic;
        end
        
        load(fullfile(analysisPrefix,[fn,'_edgeEffect.mat']));%,'bands','sumImgByBandsFromBone','sumImgByBandsFromCavity');
        clf; set(gcf,'color',[1,1,1]);
        b = MicroMeterPerPixel*linspace(min(bands),max(bands),100);
        plot(b,interp1(bands,sumImgByBandsFromBone,b,'pchip')); axis tight;
        xlabel('distance/\mum');
        ylabel('normalized intensity');
        export_fig(fullfile(pdfPrefix,sprintf('%s_%s.pdf',fn,'edge_effect_bone')));
        plot(b,interp1(bands,sumImgByBandsFromCavity,b,'pchip')); axis tight;
        xlabel('distance/\mum');
        ylabel('normalized intensity');
        export_fig(fullfile(pdfPrefix,sprintf('%s_%s.pdf',fn,'edge_effect_cavity')));
        if PROGRESSOUTPUT
            fprintf('  _edgeEffect.mat file read and printed (%gs)\n',toc);
            tic;
        end
        
        load(fullfile(analysisPrefix,[fn,'_fractions.mat']));%,'fractions');
        for i = 1:size(fractions,1)
            clf; set(gcf,'color',[1,1,1]);
            x3RegionOfInterest = fractions{i}{1};
            minSlice = round(fractions{i}{2});
            maxSlice = round(fractions{i}{3});
            bone = fractions{i}{4};
            cavity = fractions{i}{5};
            neither = fractions{i}{6};
            distances = fractions{i}{7};
            
            distances = distances*MicroMeterPerPixel;
            ind = find(distances<1000);
            ind = ind(end);
            plot(distances(1:ind), bone(1:ind));
            xlabel('distance/\mum');
            ylabel('fraction');
            if(i==size(fractions,1))
                export_fig(fullfile(pdfPrefix,sprintf('%s_%s_all.pdf',fn,'bone_fraction')));
            else
                export_fig(fullfile(pdfPrefix,sprintf('%s_%s_%d.pdf',fn,'bone_fraction',i)));
            end
            plot(distances(1:ind), cavity(1:ind));
            xlabel('distance/\mum');
            ylabel('fraction');
            if(i==size(fractions,1))
            export_fig(fullfile(pdfPrefix,sprintf('%s_%s_all.pdf',fn,'cavity_fraction')));
            else
            export_fig(fullfile(pdfPrefix,sprintf('%s_%s_%d.pdf',fn,'cavity_fraction',i)));
            end
            plot(distances(1:ind), neither(1:ind));
            xlabel('distance/\mum');
            ylabel('fraction');
            if(i==size(fractions,1))
                export_fig(fullfile(pdfPrefix,sprintf('%s_%s_all.pdf',fn,'neither_fraction')));
            else
                export_fig(fullfile(pdfPrefix,sprintf('%s_%s_%d.pdf',fn,'neither_fraction',i)));
            end
            
            clf; set(gcf,'color',[1,1,1]);
            isosurface(rotatedImplant(1:2:size(rotatedImplant,1),1:2:size(rotatedImplant,2),1:2:size(rotatedImplant,3)),0.5);
            isosurface(x3RegionOfInterest(1:2:size(x3RegionOfInterest,1),1:2:size(x3RegionOfInterest,2),1:2:size(x3RegionOfInterest,3)),0.5);
            axis equal tight
            convertUnit('xtick','xticklabel',2*MicroMeterPerPixel); xlabel('x/\mum');
            convertUnit('ytick','yticklabel',2*MicroMeterPerPixel); ylabel('y/\mum');
            convertUnit('ztick','zticklabel',2*MicroMeterPerPixel); zlabel('z/\mum');
            v = (marks(1,:)-marks(end,:))'; v = v/norm(v);
            w = cross(rand(3,1)-0.5,v); w = w/norm(w);
            set(gca,'CameraUpVector',v)
            set(gca,'CameraTarget',origo/2)
            set(gca,'CameraPosition',marks(1,:)/2+2*size(newVol,1)*w'/2)
            delete(findall(gcf,'Type','light'))
            camlight('left')
            camlight('right')
            if(i==size(fractions,1))
                export_fig(fullfile(pdfPrefix,sprintf('%s_%s_all.png',fn,'implantNfraction')));
            else
                export_fig(fullfile(pdfPrefix,sprintf('%s_%s_%d.png',fn,'implantNfraction',i)));
            end
        end
        if PROGRESSOUTPUT
            fprintf('  _fractions.mat file read and printed (%gs)\n',toc);
            tic;
        end
    end
end
