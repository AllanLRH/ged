function gedeGui
    c.backgroundColor = [0.92 0.92 0.92];  % backgroundcolor for GUI
    f = figure('visible', 'off', 'color', c.backgroundColor, 'position', [15 95 1200 730], 'toolbar', 'none', 'deleteFcn', @runAtGuiExit);
    set(f, 'name', 'Gedetands grafisk brugerflade 0.1');

    c.planeNormal_original = [0 0 1];
    c.planeNormal = [0 0 1];

    % c.zAxisFactor             = 3.74;  % Initial value
    c.zAxisFactor               = 1.0;   % Initial value
    c.volUint8                  = [];    % Initial value
    c.volDouble                 = [];    % Initial value
    c.datasetIdentifier         = '';    % Initial value
    c.loadedSegmentation        = '';    % Initial value
    c.loadedSgnDstMap           = '';    % Initial value
    c.sgnDstMap                 = [];    % Initial value
    c.implantSegmentation       = [];    % Initial value
    c.weightMask                = [];    % Initial value
    c.boneSegmentation          = [];    % Initial value
    c.crop                      = [];    % Initial value
    c.cropShadingMask           = [];    % Initial value
    c.xyzFromAutomatch          = [];    % Initial value
    c.cropFromAutomatch         = [];    % Initial value
    c.normalVectorFromAutomatch = [];    % Initial value
    c.anglesFromAutomatch       = [];    % Initial value

    % used for the file log, see the documentation for atomicLogUpdate.m for details
    c.logFolder     = 'goat_gui_log_folder'
    c.baseLogPath   = fullfile(c.logFolder, ['goat_gui_log_' datestr(now,'HH.MM.SS_dd-mm-yyyy')]);
    c.templogFid    = fopen([c.baseLogPath '_temp.txt'], 'a');
    c.sliderLogCell = cell(0);

    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    % This part defines the sliders and associated function for the x, y, z sliders %
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

    h.planeVectorMidpointLabel = uicontrol('style', 'text', 'position', [45 585 70 15], 'fontsize', 12, 'string', 'Vector origo', 'backgroundColor', c.backgroundColor);

    c.xMin = 1;
    c.xMax = 512;
    c.xInitial = 256;
    h.xSliderHandle = uicontrol('style', 'slider', 'position', [35 180 10 385], 'min', c.xMin, 'max', c.xMax, ...
        'value', c.xInitial, 'SliderStep', [1/(c.xMax-c.xMin+1), 10/(c.xMax-c.xMin+1)]);
    h.xLabelHandle =  uicontrol('style', 'text', 'position', [33 585-17 10 15], 'string', 'x', 'fontsize', 12, 'backgroundColor', c.backgroundColor);
    h.xValueHandle =  uicontrol('style', 'edit', 'position', [20 155 35 20], 'string', c.xInitial,...
                               'fontsize', 10, 'backgroundColor', 'white', 'callback', @xSliderValueInput);
    h.xSliderHandle.UserData.lastValue = c.xMin;  % Initialize to some value
    addlistener(h.xSliderHandle, 'ContinuousValueChange', @moveXSlider);

    c.yMin = 1;
    c.yMax = 512;
    c.yInitial = 256;
    h.ySliderHandle = uicontrol('style', 'slider', 'position', [35+40 180 10 385], 'min', c.yMin, 'max', c.yMax, ...
        'value', c.yInitial, 'SliderStep', [1/(c.yMax-c.yMin+1), 10/(c.yMax-c.yMin+1)]);
    h.yHandle = uicontrol('style', 'text', 'position', [33+40 585-17 10 15], 'string', 'y', 'fontsize', 12, 'backgroundColor', c.backgroundColor);
    h.yValueHandle = uicontrol('style', 'edit', 'position', [10+50 155 35 20], 'string', c.yInitial,...
                               'fontsize', 10, 'backgroundColor', 'white', 'callback', @ySliderValueInput);
    h.ySliderHandle.UserData.lastValue = c.yMin;  % Initialize to some value
    addlistener(h.ySliderHandle, 'ContinuousValueChange', @moveYSlider);

    c.zMin = 1;
    c.zMax = 250;
    c.zInitial = 125;
    h.zSliderHandle = uicontrol('style', 'slider', 'position', [115 180 10 385], 'min', c.zMin, 'max', c.zMax, ...
        'value', c.zInitial, 'SliderStep', [1/(c.zMax-c.zMin+1), 10/(c.zMax-c.zMin+1)]);
    h.zLabelHandle = uicontrol('style', 'text', 'position', [113 585-17 10 15], 'string', 'z', 'fontsize', 12, 'backgroundColor', c.backgroundColor);
    h.zValueHandle = uicontrol('style', 'edit', 'position', [10+90 155 35 20], 'string', c.zInitial,...
                               'fontsize', 10, 'backgroundColor', 'white', 'callback', @zSliderValueInput);
    h.zSliderHandle.UserData.lastValue = c.zMin;  % Initialize to some value
    addlistener(h.zSliderHandle, 'ContinuousValueChange', @moveZSlider);

    function moveXSlider(obj, sliderHandle)
        if h.xSliderHandle.UserData.lastValue ~= h.xSliderHandle.Value
            sliderValue = h.xSliderHandle.Value;
            set(h.xValueHandle, 'string', sprintf('%.3f', sliderValue))
            xMoveAction(sliderValue);
        end
    end

    function xSliderValueInput(obj, eventdata)
        newValue = str2double(get(h.xValueHandle, 'string'));
        if newValue < c.xMin
            newValue = c.xMin;
        elseif newValue > c.xMax
            newValue = c.xMax;
        end
        set(h.xSliderHandle, 'value', newValue);
        set(h.xValueHandle, 'string', sprintf('%.3f', newValue))
        xMoveAction(newValue);
    end

    function moveYSlider(obj, sliderHandle)
        if h.ySliderHandle.UserData.lastValue ~= h.ySliderHandle.Value
            sliderValue = h.ySliderHandle.Value;
            set(h.yValueHandle, 'string', sprintf('%.3f', sliderValue))
            yMoveAction(sliderValue);
        end
    end

    function ySliderValueInput(obj, eventdata)
        newValue = str2double(get(h.yValueHandle, 'string'));
        if newValue < c.yMin
            newValue = c.yMin;
        elseif newValue > c.yMax
            newValue = c.yMax;
        end
        set(h.ySliderHandle, 'value', newValue);
        set(h.yValueHandle, 'string', sprintf('%.3f', newValue))
        yMoveAction(newValue);
    end

    function moveZSlider(obj, sliderHandle)
        if h.zSliderHandle.UserData.lastValue ~= h.zSliderHandle.Value
            sliderValue = h.zSliderHandle.Value;
            set(h.zValueHandle, 'string', sprintf('%.3f', sliderValue))
            zMoveAction(sliderValue);
        end
    end

    function zSliderValueInput(obj, eventdata)
        newValue = str2double(get(h.zValueHandle, 'string'));
        if newValue < c.zMin
            newValue = c.zMin;
        elseif newValue > c.zMax
            newValue = c.zMax;
        end
        set(h.zSliderHandle, 'value', newValue);
        set(h.zValueHandle, 'string', sprintf('%.3f', newValue))
        zMoveAction(newValue);
    end

    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    % This part defines the sliders and associated function for the angle sliders %
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

    h.planeVectorLabel = uicontrol('style', 'text', 'position', [45+115 585 80 15], 'fontsize', 12, 'string', 'Vector angles', 'backgroundColor', c.backgroundColor);

    c.a1Min = 0;
    c.a1Max = 360;
    c.a1Initial = 0;
    h.a1SliderHandle = uicontrol('style', 'slider', 'position', [35+120 180 10 385], 'min', c.a1Min, 'max', c.a1Max, ...
        'value', c.a1Initial, 'SliderStep', [1/(c.a1Max-c.a1Min+1), 10/(c.a1Max-c.a1Min+1)]);
    h.a1LabelHandle =  uicontrol('style', 'text', 'position', [30+120 585-17 20 15], 'string', 'a1', 'fontsize', 12, 'backgroundColor', c.backgroundColor);
    h.a1ValueHandle =  uicontrol('style', 'edit', 'position', [20+120 155 35 20], 'string', c.a1Initial,...
                               'fontsize', 10, 'backgroundColor', 'white', 'callback', @a1SliderValueInput);
    h.a1SliderHandle.UserData.lastValue = c.a1Min;  % Initialize to some value
    addlistener(h.a1SliderHandle, 'ContinuousValueChange', @moveA1Slider);

    c.a2Min = 0;
    c.a2Max = 360;
    c.a2Initial = 0;
    h.a2SliderHandle = uicontrol('style', 'slider', 'position', [35+160 180 10 385], 'min', c.a2Min, 'max', c.a2Max, ...
        'value', c.a2Initial, 'SliderStep', [1/(c.a2Max-c.a2Min+1), 10/(c.a2Max-c.a2Min+1)]);
    h.a2LabelHandle =  uicontrol('style', 'text', 'position', [30+160 585-17 20 15], 'string', 'a2', 'fontsize', 12, 'backgroundColor', c.backgroundColor);
    h.a2ValueHandle =  uicontrol('style', 'edit', 'position', [20+160 155 35 20], 'string', c.a2Initial,...
                               'fontsize', 10, 'backgroundColor', 'white', 'callback', @a2SliderValueInput);
    h.a2SliderHandle.UserData.lastValue = c.a2Min;  % Initialize to some value
    addlistener(h.a2SliderHandle, 'ContinuousValueChange', @moveA2Slider);

    c.a3Min = 0;
    c.a3Max = 360;
    c.a3Initial = 0;
    h.a3SliderHandle = uicontrol('style', 'slider', 'position', [35+200 180 10 385], 'min', c.a3Min, 'max', c.a3Max, ...
        'value', c.a3Initial, 'SliderStep', [1/(c.a3Max-c.a3Min+1), 10/(c.a3Max-c.a3Min+1)]);
    h.a3LabelHandle =  uicontrol('style', 'text', 'position', [30+200 585-17 20 15], 'string', 'a3', 'fontsize', 12, 'backgroundColor', c.backgroundColor);
    h.a3ValueHandle =  uicontrol('style', 'edit', 'position', [20+200 155 35 20], 'string', c.a3Initial,...
                               'fontsize', 10, 'backgroundColor', 'white', 'callback', @a3SliderValueInput);
    h.a3SliderHandle.UserData.lastValue = c.a3Min;  % Initialize to some value
    addlistener(h.a3SliderHandle, 'ContinuousValueChange', @moveA3Slider);


    function moveA1Slider(obj, sliderHandle)
        if h.a1SliderHandle.UserData.lastValue ~= h.a1SliderHandle.Value
            sliderValue = h.a1SliderHandle.Value;
            set(h.a1ValueHandle, 'string', sprintf('%.1f', sliderValue))
            a1MoveAction(sliderValue);
        end
    end

    function a1SliderValueInput(obj, eventdata)
        newValue = str2double(get(h.a1ValueHandle, 'string'));
        newValue = mod(newValue, c.a1Max);
        set(h.a1SliderHandle, 'value', newValue);
        set(h.a1ValueHandle, 'string', sprintf('%.1f', newValue))
        a1MoveAction(newValue);
    end

    function moveA2Slider(obj, sliderHandle)
        if h.a2SliderHandle.UserData.lastValue ~= h.a2SliderHandle.Value
            sliderValue = h.a2SliderHandle.Value;
            set(h.a2ValueHandle, 'string', sprintf('%.1f', sliderValue))
            a2MoveAction(sliderValue);
        end
    end

    function a2SliderValueInput(obj, eventdata)
        newValue = str2double(get(h.a2ValueHandle, 'string'));
        newValue = mod(newValue, c.a2Max);
        set(h.a2SliderHandle, 'value', newValue);
        set(h.a2ValueHandle, 'string', sprintf('%.1f', newValue))
        a2MoveAction(newValue);
    end

    function moveA3Slider(obj, sliderHandle)
        if h.a3SliderHandle.UserData.lastValue ~= h.a3SliderHandle.Value
            sliderValue = h.a3SliderHandle.Value;
            set(h.a3ValueHandle, 'string', sprintf('%.1f', sliderValue))
            a3MoveAction(sliderValue);
        end
    end

    function a3SliderValueInput(obj, eventdata)
        newValue = str2double(get(h.a3ValueHandle, 'string'));
        newValue = mod(newValue, c.a3Max);
        set(h.a3SliderHandle, 'value', newValue);
        set(h.a3ValueHandle, 'string', sprintf('%.1f', newValue))
        a3MoveAction(newValue);
    end

    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    % The button and associated callback function which activates the difference minimization function  %
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    h.automatchButtonHandle = uicontrol('style', 'pushbutton', 'string', 'Automatch', 'fontsize', 12, 'position', [30 95 100 50], 'callback', @automatch);

    h.makeFiguresCheckboxText = uicontrol('style', 'text', 'string', 'Show figures during alignment', 'fontsize', 12, ...
        'backgroundColor', c.backgroundColor, 'position', [130 110 150 30]);
    h.makeFiguresCheckbox = uicontrol('style', 'checkbox', 'value', 0, 'position', [130 115 15 15]);

    function automatch(obj, eventdata)
        if isempty(c.histologyShowImage) || isempty(c.volUint8)
            postMessage('Please load a histology image and a CT scan before attempting to automatch.')
        elseif isempty(c.crop)
            postMessage('Please specify crop values using the crop button.')
        else
            [xyz, angles] = getParametersFromSliders;  % c.planeNormal is also updated
            postMessage(sprintf('Normal vector components with automatch cootdinates: %.2f, %.2f, %.2f', c.planeNormal(1), c.planeNormal(2), c.planeNormal(3)))
            postMessage(sprintf('Attepting automatch at theese coordinates: x=%.2f, y=%.2f, z=%.2f, a1=%.2f, a2=%.2f, A3=%.2f',...
                        xyz(1), xyz(2), xyz(3), angles(1), angles(2), angles(3)));
            postMessage('Automatching will likely freeze the program for several minutes.')

            sigma = 10;
            makeFigures = logical(get(h.makeFiguresCheckbox, 'Value'));
            if logical(get(h.weightMaskCheckbox, 'Value'))
                useMask = c.weightMask;
            else
                useMask = ones(size(c.volUint8, 1)+1, size(c.volUint8, 2)+1);
            end
            [c.xyzFromAutomatch, c.cropFromAutomatch, c.normalVectorFromAutomatch, c.anglesFromAutomatch] = ...
                alignImages(c.volUint8, c.histologyShowImage, useMask, c.zAxisFactor, sigma, xyz, c.crop, c.planeNormal, angles, makeFigures);
            postMessage(sprintf('xyz:  %s', num2str(c.xyzFromAutomatch)))
            postMessage(sprintf('crop:  %s', num2str(c.cropFromAutomatch)))
            postMessage(sprintf('normalVector:  %s', num2str(c.normalVectorFromAutomatch)))
            postMessage(sprintf('angles:  %s', num2str(c.anglesFromAutomatch)))
        end
    end

    h.matchCavitiesButtonHandle = uicontrol('style', 'pushbutton', 'string', 'Match cavities', 'fontsize', 12, 'position', [275 95 100 50], 'callback', @matchCavities);
    function matchCavities(obj, eventdata)
        if isempty(c.histologyShowImage) || isempty(c.volUint8)
            postMessage('Please load a histology image and a CT scan before attempting to automatch.')
        elseif isempty(c.xyzFromAutomatch)
            postMessage('Please run "Automatch" before running the cavity match.')
        else
            loadSegmentation;
            volUint8NaNImplant = c.volUint8;
            volUint8NaNImplant(c.implantSegmentation) = NaN;
            postMessage(sprintf('Normal vector components with automatch cootdinates: %.2f, %.2f, %.2f', c.normalVectorFromAutomatch(1),...
                c.normalVectorFromAutomatch(2), c.normalVectorFromAutomatch(3)))
            postMessage(sprintf('Attepting automatch at theese coordinates: x=%.2f, y=%.2f, z=%.2f, a1=%.2f, a2=%.2f, A3=%.2f', c.xyzFromAutomatch(1),...
                c.xyzFromAutomatch(2), c.xyzFromAutomatch(3), c.anglesFromAutomatch(1), c.anglesFromAutomatch(2), c.anglesFromAutomatch(3)));
            postMessage('Automatching will likely freeze the program for several minutes.')

            postMessage(sprintf('Current crop is %.2f, %.2f, %.2f, %.2f', c.cropFromAutomatch(1), c.cropFromAutomatch(2), c.cropFromAutomatch(3), c.cropFromAutomatch(4)))
            makeFigures = logical(get(h.makeFiguresCheckbox, 'Value'));
            if logical(get(h.weightMaskCheckbox, 'Value'))
                useMask = c.weightMask;
            else
                useMask = ones(size(c.volUint8, 1)+1, size(c.volUint8, 2)+1);
            end
            [c.xyzFromAutomatch, c.cropFromAutomatch, c.normalVectorFromAutomatch, c.anglesFromAutomatch] = ...
            alignImages(volUint8NaNImplant, c.histologyShowImage, useMask, c.zAxisFactor, sigma, c.xyzFromAutomatch, c.cropFromAutomatch, ...
                c.normalVectorFromAutomatch, c.anglesFromAutomatch, makeFigures);;
            postMessage(sprintf('xyz:  %s', num2str(c.xyzFromAutomatch)))
            postMessage(sprintf('crop:  %s', num2str(c.cropFromAutomatch)))
            postMessage(sprintf('normalVector:  %s', num2str(c.normalVectorFromAutomatch)))
            postMessage(sprintf('angles:  %s', num2str(c.anglesFromAutomatch)))
        end
    end


    h.weightMaskCheckboxText = uicontrol('style', 'text', 'string', 'Sigma for Gaussian', 'fontsize', 12, 'backgroundColor', c.backgroundColor, ...
        'position', [710 85 100 50], 'callback', @makeWeightMask);
    h.weightMaskSigma        = uicontrol('style', 'edit', 'string', '0', 'fontsize', 12, 'backgroundColor', 'white', 'position', [655 105 65 30]);
    h.weightMaskCheckbox     = uicontrol('style', 'checkbox', 'value', 0, 'position', [630 115 15 15]);
    function makeWeightMask(obj, eventdata)
        sigma = str2double(get(h.weightMaskSigma, 'string'));
        postMessage(sprintf('Creating c.weightMask using sigma = %.3f', sigma));
        if isempty(c.implantSegmentation)
            loadSegmentation;
        end
        c.weightMask = imgaussfilt3(double(~c.implantSegmentation), sigma);;
    end


    % % % % % % % % % % % % % % % % % % % % % % % % % % %
    % Set crop button and associated callback function  %
    % % % % % % % % % % % % % % % % % % % % % % % % % % %

    h.cropHistologyButtonHandle = uicontrol('style', 'pushbutton', 'string', 'Set crop', 'fontsize', 12, 'position', [395 95 100 50], 'callback', @setCrop);

    function setCrop(obj, eventdata)
        [X,Y] = ginput2(2, axisRight);
        c.crop(1) = X(1);  c.crop(2) = Y(1);
        c.crop(3) = X(2); c.crop(4) = Y(2);
        postMessage(sprintf('Current crop is %.2f, %.2f, %.2f, %.2f', c.crop(1), c.crop(2), c.crop(3), c.crop(4)))
        [row, col] = ndgrid(1:size(c.histologyShowImage, 1), 1:size(c.histologyShowImage, 2));
        rc = row <= c.crop(1) | row > c.crop(3);
        cc = col <= c.crop(2) | col > c.crop(4);
        c.cropShadingMask = rc|cc;
        axes(axisRight);
        shadeArea(c.cropShadingMask, [0 0 0], 0.4)
    end


    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    % The button and associated callback function which computes statistics for given slice from the segmentation %
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    h.getStatsButtonHandle = uicontrol('style', 'pushbutton', 'string', 'Get statistics', 'fontsize', 12, 'position', [510 95 100 50], 'callback', @getStats);

    function getStats(obj, eventdata)
        postMessage('Getting statistics for current slice')
        loadSegmentation;
        loadSgnDstMap;
        [xyz, angles] = getParametersFromSliders;  % c.planeNormal is also updated
        % NOTE: midpoints and 512^2 vs 513^2 area sizes are potential soruces of errors!
        dstMap = extractSlice(c.sgnDstMap, xyz(1), xyz(2), xyz(3), c.planeNormal(1), c.planeNormal(2),...
                    c.planeNormal(3), max([size(c.sgnDstMap, 1), size(c.sgnDstMap, 2)])/2, c.zAxisFactor, angles);
        boneslice = extractSlice(double(c.boneSegmentation), xyz(1), xyz(2), xyz(3), c.planeNormal(1), c.planeNormal(2),...
                    c.planeNormal(3), max([size(c.boneSegmentation, 1), size(c.boneSegmentation, 2)])/2, c.zAxisFactor, angles);
        [boneVolume, volume] = boneFractionFunction(boneslice, dstMap, 120);
        csvwrite(sprintf('csvfiles/%s___x_%.2f_y_%.2f_z_%.2f___a1_%.2f_a2_%.2f_a3_%.2f_boneVolume.csv', c.datasetIdentifier, xyz(1), xyz(2), ...
                          xyz(3), angles(1), angles(2), angles(3)), 'boneVolume');
        csvwrite(sprintf('csvfiles/%s___x_%.2f_y_%.2f_z_%.2f___a1_%.2f_a2_%.2f_a3_%.2f_volume.csv', c.datasetIdentifier, xyz(1), xyz(2), ...
                          xyz(3), angles(1), angles(2), angles(3)), 'volume');
%         figure(42)
%         hold on
%         plot(boneVolume)
%         plot(volume)
%         hold off
    end


    % % % % % % % % % % % % % % % % % % %
    % Relating to z-axis factor values  %
    % % % % % % % % % % % % % % % % % % %
    h.zAxisFactorLabel = uicontrol('style', 'text', 'position', [20 600+15 150 30], 'fontsize', 12, 'string', 'Z-axis factor', 'backgroundColor', c.backgroundColor);
    h.zAxisFactorHandle = uicontrol('style', 'edit', 'position', [135 605+15 65 30], 'fontsize', 10, ...
        'backgroundColor', 'white', 'string', c.zAxisFactor, 'callback', @setZAxisFactor);

    function setZAxisFactor(obj, eventdata)
        newZAxisFactor = str2double(get(h.zAxisFactorHandle, 'string'));
        if newZAxisFactor > 0
            oldzAxisFactor = c.zAxisFactor;
            c.zAxisFactor = newZAxisFactor;
            postMessage(sprintf('Changed z-axis factor from %.2f to %.2f', oldzAxisFactor, newZAxisFactor))
            updateView;
        else
            postMessage(sprintf('The Z-axis factor must be larger than 0 (you entered %.2f). The Z-axis factor haven''t been changed', newZAxisFactor))
            set(h.zAxisFactorHandle, 'string', c.zAxisFactor)
        end
    end


    % % % % % % % % % % % % % % % % % % % % % % %
    % Relating to data folder and file loading  %
    % % % % % % % % % % % % % % % % % % % % % % %
    c.histologyFilePath = '';  % Initial value
    c.dataPath = '';  % Initial value
    h.loadDatasetButtonHandle = uicontrol('style', 'pushbutton', 'string', 'Load a dataset', 'fontsize', 12, 'position', [30 675+15 215 30], 'callback', @loadDataset);
    c.histologyImage = [];  % Initial value
    c.histologyShowImage = [];  % Initial value
    h.loadHistologyButtonHandle = uicontrol('style', 'pushbutton', 'string', 'Load histology image', ...
        'fontsize', 12, 'position', [30 640+15 215 30], 'callback', @loadHistologyImage);

    function loadHistologyImage(obj, eventdata)
        [filename, filepath] = uigetfile('*.tif', 'Select a histology image file');
        if filepath ~= 0
            c.histologyFilePath = fullfile(filepath, filename);
            c.histologyImage = double(rgb2gray(imread(c.histologyFilePath)));
            c.histologyShowImage = imresize(c.histologyImage, [512, 512]);
            postMessage(sprintf('Loaded the histology image "%s"', c.histologyFilePath))
            updateView
        end
    end


    function loadDataset(obj, eventdata)
        [filename, filepath] = uigetfile('*.vol', 'Select a .vol-file from a dataset');
        if filepath ~= 0
            c.datasetIdentifier = filename(1:end-9);
            postMessage(sprintf('Loading the dataset %s, please be patient', c.datasetIdentifier))
            pause(0.01)
            c.volUint8 = load(['smallData/' c.datasetIdentifier '_v7.3_uint8.mat']);
            c.volUint8 = c.volUint8.newVol;
            postMessage(sprintf('Loaded integer 8 version of dataset %s', c.datasetIdentifier))
            % volDouble = load(['smallData/' datasetIdentifier '_v7.3_double.mat']);
            % volDouble = volDouble.newVol;
            % postMessage(sprintf('Loaded double precision version of dataset %s', datasetIdentifier))
            c.weightMask = ones([size(c.volUint8, 1)+1, size(c.volUint8, 2)+1]);  % +1 because the extractSlice function adds 1 pixel in each dimmension;
            postMessage(sprintf('Loaded scaled version of the dataset %s with size %d x %d x %d', ...
                c.datasetIdentifier, size(c.volUint8, 1), size(c.volUint8, 2), size(c.volUint8, 3)))
            updateView
        end
    end


    function loadSegmentation
        if strcmp(c.loadedSegmentation, c.datasetIdentifier)
            postMessage(sprintf('Segmentation for %s allreaddy loaded, reusing data', c.datasetIdentifier))
        else
            postMessage(sprintf('Loading the segmentations for %s, please be patient, this will take quite a while', c.datasetIdentifier))
            pause(0.01)
            temp = load(['smallSegmentations/' c.datasetIdentifier '_double.mat']);
            c.loadedSegmentation = c.datasetIdentifier;
            c.boneSegmentation = temp.savedBoneMasks;
            c.implantSegmentation = temp.savedImplantMasks;
            postMessage(sprintf('Loaded segmentation for the dataset %s with size %d x %d x %d', c.datasetIdentifier, ...
                size(c.boneSegmentation, 1), size(c.boneSegmentation, 2), size(c.boneSegmentation, 3)))
        end
    end

    function loadSgnDstMap
        if strcmp(c.loadedSgnDstMap, c.datasetIdentifier)
            postMessage(sprintf('Signed distance map for %s allreaddy loaded, reusing data', c.datasetIdentifier))
        else
            postMessage(sprintf('Loading the signed distance map for %s, please be patient, this will take quite a while', c.datasetIdentifier))
            pause(0.01)
            temp = load(['smallSegmentations/' c.datasetIdentifier '_doublesgnDstMap.mat']);
            c.loadedSgnDstMap = c.datasetIdentifier;
            c.sgnDstMap = temp.dstMap;
            postMessage(sprintf('Loaded signed distance map for the dataset %s with size %d x %d x %d', c.datasetIdentifier, ...
                size(c.sgnDstMap, 1), size(c.sgnDstMap, 2), size(c.sgnDstMap, 3)))
        end
    end


    % % % % % % % % % % % % % % %
    % This handles the logging  %
    % % % % % % % % % % % % % % %
    c.logCell = {'This is the log panel, new entries appear on top'};
    h.logPanelHandle =  uicontrol('style', 'edit', 'position', [30 20 1130 65], 'string', c.logCell, 'fontsize', 10, 'fontname', 'Courier New',...
                                'backgroundColor', 'white', 'enable', 'inactive', 'max', 999999, 'min', 1);

    function postMessage(message)
        % Handles logging. Writes message to log. Appends date to hte right, because Matlab doesn't allow any alignment but centered.
        paddedMessage = padString(message, 162);
        c.logCell = cat(1, paddedMessage, c.logCell);
        set(h.logPanelHandle, 'string', c.logCell);

        atomicLogUpdate(c.templogFid, c.baseLogPath, paddedMessage)

        function padded = padString(inString, len)
            % Pads inString with spaces and a datetime to the right
            paddingLength = len - length(inString);
            if paddingLength > 0
                padded = [inString, repmat(' ', [1, paddingLength]), datestr(now,'HH:MM:SS dd/mm/yyyy/')];
            else
                padded = inString;
            end
        end % padded

    end  % postMessage


    function runAtGuiExit(obj, eventdata)
        % Runs when the GUI is closed
        % Close the filehandle for the logfile, and delete the temporary log if sucessful
        closeStatus = fclose(c.templogFid);  % Close logfile on exit
        if closeStatus == 0  % if closed sucessfully...
            delete([c.baseLogPath '_temp.txt'])  % ...remove the temporary logfile
        end
    end


    function xMoveAction(newValue)
        updateView;
        postMessage(sprintf('Set X-slider to %.3f', newValue))
        c.sliderLogCell{length(c.sliderLogCell)+1} = {{'x', newValue}};
    end


    function yMoveAction(newValue)
        updateView;
        postMessage(sprintf('Set Y-slider to %.3f', newValue))
        c.sliderLogCell{length(c.sliderLogCell)+1} = {{'y', newValue}};
    end


    function zMoveAction(newValue)
        updateView;
        postMessage(sprintf('Set Z-slider to %.3f', newValue))
        c.sliderLogCell{length(c.sliderLogCell)+1} = {{'z', newValue}};
    end


    function a1MoveAction(newValue)
        updateView;
        postMessage(sprintf('Set A1-slider to %.1f', newValue))
        c.sliderLogCell{length(c.sliderLogCell)+1} = {{'a1', newValue}};
    end


    function a2MoveAction(newValue)
        updateView;
        postMessage(sprintf('Set A2-slider to %.1f', newValue))
        c.sliderLogCell{length(c.sliderLogCell)+1} = {{'a2', newValue}};
    end


    function a3MoveAction(newValue)
        updateView;
        postMessage(sprintf('Set A3-slider to %.1f', newValue))
        c.sliderLogCell{length(c.sliderLogCell)+1} = {{'a3', newValue}};
    end

    function [xyz, angles] = getParametersFromSliders
        xyz(1) = h.xSliderHandle.Value;
        xyz(2) = h.ySliderHandle.Value;
        xyz(3) = h.zSliderHandle.Value;
        angles(1) = h.a1SliderHandle.Value; % * pi/180;
        angles(2) = h.a2SliderHandle.Value; % * pi/180;
        angles(3) = h.a3SliderHandle.Value; % * pi/180;
        c.planeNormal(1) = cosd(angles(1))*sind(angles(2));
        c.planeNormal(2) = sind(angles(1))*sind(angles(2));
        c.planeNormal(3) = cosd(angles(2));
    end

    axisLeft = axes('units', 'pixels', 'position', [310 175 395 395]);
    axisRight = axes('units', 'pixels', 'position', [773 175 395 395]);
    function updateView
        % if (isempty(volUint8) && ~isempty(histologyShowImage)) || (isempty(histologyShowImage) && ~isempty(volUint8))
            % handles.axisSingle = axes('units', 'pixels', 'position', [350 130 570 570]);
        % else
            % handles.axisLeft = axes('units', 'pixels', 'position', [310 175 395 395]);
            % handles.axisRight = axes('units', 'pixels', 'position', [773 175 395 395]);
        % end

        [xyz, angles] = getParametersFromSliders;  % c.planeNormal is also updated
        if not(isempty(c.volUint8)) && not(isempty(c.histologyShowImage))
            imslice = extractSlice(c.volUint8, xyz(1), xyz(2), xyz(3), c.planeNormal(1), c.planeNormal(2), c.planeNormal(3), ...
                max([size(c.volUint8, 1), size(c.volUint8, 2)])/2, c.zAxisFactor, angles);
            % Plot in left axis
            axes(axisLeft);
            imagesc(imslice);
            colormap('gray');
            set(axisLeft, 'xTick', []);
            set(axisLeft, 'yTick', []);
            % Plot in right axis
            axes(axisRight);
            imagesc(c.histologyShowImage);
            colormap('gray');
            set(axisRight, 'xTick', []);
            set(axisRight, 'yTick', []);
            if not(isempty(c.cropShadingMask))
                shadeArea(c.cropShadingMask, [0 0 0], 0.4)
            end
        elseif not(isempty(c.volUint8))
            imslice = extractSlice(c.volUint8, xyz(1), xyz(2), xyz(3), c.planeNormal(1), c.planeNormal(2), c.planeNormal(3), ...
                max([size(c.volUint8, 1), size(c.volUint8, 2)])/2, c.zAxisFactor, angles);
            % axes(handles.axisSingle);
            axes(axisLeft);
            imagesc(imslice)
            colormap('gray');
            set(axisLeft, 'xTick', []);
            set(axisLeft, 'yTick', []);
            % set(handles.axisSingle, 'xTick', []);
            % set(handles.axisSingle, 'yTick', []);
        elseif not(isempty(c.histologyShowImage))
            % axes(handles.axisSingle);
            axes(axisRight);
            imagesc(c.histologyShowImage)
            colormap('gray');
            set(axisRight, 'xTick', []);
            set(axisRight, 'yTick', []);
            if not(isempty(c.cropShadingMask))
                shadeArea(c.cropShadingMask, [0 0 0], 0.4)
            end
            % set(handles.axisSingle, 'xTick', []);
            % set(handles.axisSingle, 'yTick', []);
        end
        optimizeMe = false;
        if ~isempty(c.histologyShowImage)
            if (optimizeMe)
                sigma = 10;
                c.crop = [-11.9, 397.6, 92.0, 418.8];
                alignImages(c.volUint8, c.histologyShowImage, c.weightMask, c.zAxisFactor, sigma, xyz, c.crop, c.planeNormal, angles, false);
                figure(1);
            end
        end
    end

    set(f, 'visible', 'on');

end
