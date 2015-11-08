    function gedeGui
    backgroundColor = [0.92 0.92 0.92];  % backgroundcolor for GUI
    f = figure('visible', 'off', 'color', backgroundColor, 'position', [15 95 955 730], 'toolbar', 'none', 'deleteFcn', @runAtGuiExit);
    set(f, 'name', 'Gedetands grafisk brugerflade 0.1');

    planeNormal_original = [0 0 1];
    planeNormal = [0 0 1];

    zAxisFactor = 3.74;  % Initial value
    volUint8 = [];  % Initial value
    volDouble = [];  % Initial value

    % used for the file log, see the documentation for atomicLogUpdate.m for details
    baseLogName = 'goat_gui_log';
    templogFid = fopen([baseLogName '_temp.txt'], 'a');

    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    % This part defines the sliders and associated function for the x, y, z sliders %
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

    planeVectorMidpointLabel = uicontrol('style', 'text', 'position', [45 585 70 15], 'fontsize', 12, 'string', 'Vector origo', 'backgroundColor', backgroundColor);

    xMin = 1;
    xMax = 512;
    xSliderHandle = uicontrol('style', 'slider', 'position', [35 180 10 385], 'min', xMin, 'max', xMax, 'Value', 256, 'SliderStep', [1/(xMax-xMin+1), 10/(xMax-xMin+1)]);
    xLabelHandle =  uicontrol('style', 'text', 'position', [33 585-17 10 15], 'string', 'x', 'fontsize', 12, 'backgroundColor', backgroundColor);
    xValueHandle =  uicontrol('style', 'edit', 'position', [20 155 35 20], 'string', xSliderHandle.Value,...
                               'fontsize', 10, 'backgroundColor', 'white', 'callback', @xSliderValueInput);
    xSliderHandle.UserData.lastValue = xMin;  % Initialize to some value
    addlistener(xSliderHandle, 'ContinuousValueChange', @moveXSlider);

    yMin = 1;
    yMax = 512;
    ySliderHandle = uicontrol('style', 'slider', 'position', [35+40 180 10 385], 'min', yMin, 'max', yMax, 'Value', 256, 'SliderStep', [1/(yMax-yMin+1), 10/(yMax-yMin+1)]);
    yHandle = uicontrol('style', 'text', 'position', [33+40 585-17 10 15], 'string', 'y', 'fontsize', 12, 'backgroundColor', backgroundColor);
    yValueHandle = uicontrol('style', 'edit', 'position', [10+50 155 35 20], 'string', ySliderHandle.Value,...
                               'fontsize', 10, 'backgroundColor', 'white', 'callback', @ySliderValueInput);
    ySliderHandle.UserData.lastValue = yMin;  % Initialize to some value
    addlistener(ySliderHandle, 'ContinuousValueChange', @moveYSlider);

    zMin = 1;
    zMax = 1000;
    zSliderHandle = uicontrol('style', 'slider', 'position', [115 180 10 385], 'min', zMin, 'max', zMax, 'Value', 512, 'SliderStep', [1/(zMax-zMin+1), 10/(zMax-zMin+1)]);
    zLabelHandle = uicontrol('style', 'text', 'position', [113 585-17 10 15], 'string', 'z', 'fontsize', 12, 'backgroundColor', backgroundColor);
    zValueHandle = uicontrol('style', 'edit', 'position', [10+90 155 35 20], 'string', zSliderHandle.Value,...
                               'fontsize', 10, 'backgroundColor', 'white', 'callback', @zSliderValueInput);
    zSliderHandle.UserData.lastValue = zMin;  % Initialize to some value
    addlistener(zSliderHandle, 'ContinuousValueChange', @moveZSlider);

    function moveXSlider(obj, sliderHandle)
        if xSliderHandle.UserData.lastValue ~= xSliderHandle.Value
            sliderValue = xSliderHandle.Value;
            set(xValueHandle, 'string', sprintf('%.3f', sliderValue))
            xMoveAction;
            postMessage(sprintf('Set X-slider to %.3f', sliderValue))
        end
    end

    function xSliderValueInput(obj, eventdata)
        newValue = str2double(get(xValueHandle, 'string'));
        if newValue < xMin
            newValue = xMin;
        elseif newValue > xMax
            newValue = xMax;
        end
        set(xSliderHandle, 'value', newValue);
        set(xValueHandle, 'string', sprintf('%.3f', newValue))
        xMoveAction;
    end

    function moveYSlider(obj, sliderHandle)
        if ySliderHandle.UserData.lastValue ~= ySliderHandle.Value
            sliderValue = ySliderHandle.Value;
            set(yValueHandle, 'string', sprintf('%.3f', sliderValue))
            yMoveAction;
            postMessage(sprintf('Set Y-slider to %.3f', sliderValue))
        end
    end

    function ySliderValueInput(obj, eventdata)
        newValue = str2double(get(yValueHandle, 'string'));
        if newValue < yMin
            newValue = yMin;
        elseif newValue > yMax
            newValue = yMax;
        end
        set(ySliderHandle, 'value', newValue);
        set(yValueHandle, 'string', sprintf('%.3f', newValue))
        yMoveAction;
    end

    function moveZSlider(obj, sliderHandle)
        if zSliderHandle.UserData.lastValue ~= zSliderHandle.Value
            sliderValue = zSliderHandle.Value;
            set(zValueHandle, 'string', sprintf('%.3f', sliderValue))
            zMoveAction;
            postMessage(sprintf('Set Z-slider to %.3f', sliderValue))
        end
    end

    function zSliderValueInput(obj, eventdata)
        newValue = str2double(get(zValueHandle, 'string'));
        if newValue < zMin
            newValue = zMin;
        elseif newValue > zMax
            newValue = zMax;
        end
        set(zSliderHandle, 'value', newValue);
        set(zValueHandle, 'string', sprintf('%.3f', newValue))
        zMoveAction;
    end

    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    % This part defines the sliders and associated function for the angle sliders %
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

    planeVectorLabel = uicontrol('style', 'text', 'position', [45+115 585 80 15], 'fontsize', 12, 'string', 'Vector angles', 'backgroundColor', backgroundColor);

    a1Min = 0;
    a1Max = 360;
    a1SliderHandle = uicontrol('style', 'slider', 'position', [35+120 180 10 385], 'min', a1Min, 'max', a1Max, 'value', 0, 'SliderStep', [1/(a1Max-a1Min+1), 10/(a1Max-a1Min+1)]);
    a1LabelHandle =  uicontrol('style', 'text', 'position', [30+120 585-17 20 15], 'string', 'a1', 'fontsize', 12, 'backgroundColor', backgroundColor);
    a1ValueHandle =  uicontrol('style', 'edit', 'position', [20+120 155 35 20], 'string', a1SliderHandle.Value,...
                               'fontsize', 10, 'backgroundColor', 'white', 'callback', @a1SliderValueInput);
    a1SliderHandle.UserData.lastValue = a1Min;  % Initialize to some value
    addlistener(a1SliderHandle, 'ContinuousValueChange', @moveA1Slider);

    a2Min = 0;
    a2Max = 360;
    a2SliderHandle = uicontrol('style', 'slider', 'position', [35+160 180 10 385], 'min', a2Min, 'max', a2Max, 'value', 0, 'SliderStep', [1/(a2Max-a2Min+1), 10/(a2Max-a2Min+1)]);
    a2LabelHandle =  uicontrol('style', 'text', 'position', [30+160 585-17 20 15], 'string', 'a2', 'fontsize', 12, 'backgroundColor', backgroundColor);
    a2ValueHandle =  uicontrol('style', 'edit', 'position', [20+160 155 35 20], 'string', a2SliderHandle.Value,...
                               'fontsize', 10, 'backgroundColor', 'white', 'callback', @a2SliderValueInput);
    a2SliderHandle.UserData.lastValue = a2Min;  % Initialize to some value
    addlistener(a2SliderHandle, 'ContinuousValueChange', @moveA2Slider);

    a3Min = 0;
    a3Max = 360;
    a3SliderHandle = uicontrol('style', 'slider', 'position', [35+200 180 10 385], 'min', a3Min, 'max', a3Max, 'value', 0, 'SliderStep', [1/(a3Max-a3Min+1), 10/(a3Max-a3Min+1)]);
    a3LabelHandle =  uicontrol('style', 'text', 'position', [30+200 585-17 20 15], 'string', 'a3', 'fontsize', 12, 'backgroundColor', backgroundColor);
    a3ValueHandle =  uicontrol('style', 'edit', 'position', [20+200 155 35 20], 'string', a3SliderHandle.Value,...
                               'fontsize', 10, 'backgroundColor', 'white', 'callback', @a3SliderValueInput);
    a3SliderHandle.UserData.lastValue = a3Min;  % Initialize to some value
    addlistener(a3SliderHandle, 'ContinuousValueChange', @moveA3Slider);


    function moveA1Slider(obj, sliderHandle)
        if a1SliderHandle.UserData.lastValue ~= a1SliderHandle.Value
            sliderValue = a1SliderHandle.Value;
            set(a1ValueHandle, 'string', sprintf('%.1f', sliderValue))
            a1MoveAction;
            postMessage(sprintf('Set A-1slider to %.1f', sliderValue))
        end
    end

    function a1SliderValueInput(obj, eventdata)
        newValue = str2double(get(a1ValueHandle, 'string'));
        newValue = mod(newValue, a1Max);
        set(a1SliderHandle, 'value', newValue);
        set(a1ValueHandle, 'string', sprintf('%.1f', newValue))
        a1MoveAction;
    end

    function moveA2Slider(obj, sliderHandle)
        if a2SliderHandle.UserData.lastValue ~= a2SliderHandle.Value
            sliderValue = a2SliderHandle.Value;
            set(a2ValueHandle, 'string', sprintf('%.1f', sliderValue))
            a2MoveAction;
            postMessage(sprintf('Set A-2slider to %.1f', sliderValue))
        end
    end

    function a2SliderValueInput(obj, eventdata)
        newValue = str2double(get(a2ValueHandle, 'string'));
        newValue = mod(newValue, a2Max);
        set(a2SliderHandle, 'value', newValue);
        set(a2ValueHandle, 'string', sprintf('%.1f', newValue))
        a2MoveAction;
    end

    function moveA3Slider(obj, sliderHandle)
        if a3SliderHandle.UserData.lastValue ~= a3SliderHandle.Value
            sliderValue = a3SliderHandle.Value;
            set(a3ValueHandle, 'string', sprintf('%.1f', sliderValue))
            a3MoveAction;
            postMessage(sprintf('Set A-3slider to %.1f', sliderValue))
        end
    end

    function a3SliderValueInput(obj, eventdata)
        newValue = str2double(get(a3ValueHandle, 'string'));
        newValue = mod(newValue, a3Max);
        set(a3SliderHandle, 'value', newValue);
        set(a3ValueHandle, 'string', sprintf('%.1f', newValue))
        a3MoveAction;
    end

    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    % The button and associated callback function which activates the entropy minimization function %
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    magicButtonHandle = uicontrol('style', 'pushbutton', 'string', 'Magic!', 'fontsize', 12, 'position', [30 95 215 50], 'callback', @useMagic);

    function useMagic(obj, eventdata)
        % STUB
        postMessage('Using magic!')
    end


    % % % % % % % % % % % % % % % % % % %
    % Relating to z-axis factor values  %
    % % % % % % % % % % % % % % % % % % %
    zAxisFactorLabel = uicontrol('style', 'text', 'position', [20 600+15 150 30], 'fontsize', 12, 'string', 'Z-axis factor', 'backgroundColor', backgroundColor);
    zAxisFactorHandle = uicontrol('style', 'edit', 'position', [135 605+15 65 30], 'fontsize', 10, 'backgroundColor', 'white', 'string', zAxisFactor, 'callback', @setZAxisFactor);

    function setZAxisFactor(obj, eventdata)
        newZAxisFactor = str2double(get(zAxisFactorHandle, 'string'));
        if newZAxisFactor > 0
            oldzAxisFactor = zAxisFactor;
            zAxisFactor = newZAxisFactor;
            postMessage(sprintf('Changed z-axis factor from %.2f to %.2f', oldzAxisFactor, newZAxisFactor))
            updateView;
        else
            postMessage(sprintf('The Z-axis factor must be larger than 0 (you entered %.2f). The Z-axis factor haven''t been changed', newZAxisFactor))
            set(zAxisFactorHandle, 'string', zAxisFactor)
        end
    end



    % % % % % % % % % % % % % % % % % % % % % % %
    % Relating to data folder and file loading  %
    % % % % % % % % % % % % % % % % % % % % % % %
    histologyFilePath = '';  % Initial value
    dataPath = '';  % Initial value
    loadDatasetButtonHandle = uicontrol('style', 'pushbutton', 'string', 'Load a dataset', 'fontsize', 12, 'position', [30 675+15 215 30], 'callback', @loadDataset);
    histologyImage = [];  % Initial value
    histologyShowImage = [];  % Initial value
    loadHistologyButtonHandle = uicontrol('style', 'pushbutton', 'string', 'Load histology image', 'fontsize', 12, 'position', [30 640+15 215 30], 'callback', @loadHistologyImage);

    function loadHistologyImage(obj, eventdata)
        [filename, filepath] = uigetfile('*.tif', 'Select a histology image file');
        if filepath ~= 0
            histologyFilePath = fullfile(filepath, filename);
            histologyImage = rgb2gray(imread(histologyFilePath));
            histologyShowImage = imresize(histologyImage, [512 512]);
            postMessage(sprintf('Loaded the histology image "%s"', histologyFilePath))
            updateView
        end
    end

    function loadDataset(obj, eventdata)
        [filename, filepath] = uigetfile('*.vol', 'Select a .vol-file from a dataset');
        if filepath ~= 0
            datasetIdentifier = filename(1:end-9);
            postMessage(sprintf('Loading the dataset %s, please be patient', datasetIdentifier))
            pause(0.01)
            volUint8 = load(['smallData/' datasetIdentifier '_v7.3_uint8.mat']);
            volUint8 = volUint8.newVol;
            postMessage(sprintf('Loaded integer 8 version of dataset %s', datasetIdentifier))
            % volDouble = load(['smallData/' datasetIdentifier '_v7.3_double.mat']);
            % volDouble = volDouble.newVol;
            % postMessage(sprintf('Loaded double precision version of dataset %s', datasetIdentifier))
            postMessage(sprintf('Loaded scaled version of the dataset %s with size %d x %d x %d', datasetIdentifier, size(volUint8, 1), size(volUint8, 2), size(volUint8, 3)))
            updateView
        end
    end

    function getDropdownDataSTUB
        % STUB -- just list all filenames for now
        postMessage('Gathering datasets, please wait...')
        dirCont = dir(dataPath);
        avaiableDatasets = {dirCont.name};
        [~, regexMatch] = regexp(avaiableDatasets, '^\.+$', 'match');
        avaiableDatasets = {avaiableDatasets{cellfun(@isempty, regexMatch)}};

        % For testing purposes
        tempCell = {};
        for ii = 1:length(avaiableDatasets)
            name = avaiableDatasets{ii};
            if strcmp(name(end-3:end), '.mat')
                tempCell{length(tempCell)+1} = name;
            end
        end
        avaiableDatasets = tempCell;
        if isempty(avaiableDatasets)
            postMessage(sprintf('No datasets found at %s', dataPath))
        else
            set(selectDataPopupHandle, 'string', avaiableDatasets);
            postMessage('Finished gathering datasets')
        end
        % outData = {'foo', 'bar', 'baz'};
    end


    % % % % % % % % % % % % % % % % % % % % % % %
    % Handle for image axes (image in the GUI)  %
    % % % % % % % % % % % % % % % % % % % % % % %
    imageAxesHandle = axes('units', 'pixels', 'position', [350 130 570 570]);



    % % % % % % % % % % % % % % %
    % This handles the logging  %
    % % % % % % % % % % % % % % %
    logCell = {'This is the log panel, new entries appear on top'};
    logPanelHandle =  uicontrol('style', 'edit', 'position', [30 20 890 65], 'string', logCell, 'fontsize', 10, 'fontname', 'Courier New',...
                                'backgroundColor', 'white', 'enable', 'inactive', 'max', 999999, 'min', 1);

    function postMessage(message)
        % Handles logging. Writes message to log. Appends date to hte right, because Matlab doesn't allow any alignment but centered.
        paddedMessage = padString(message, 124);
        logCell = cat(1, paddedMessage, logCell);
        set(logPanelHandle, 'string', logCell);

        atomicLogUpdate(templogFid, baseLogName, paddedMessage)

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
        closeStatus = fclose(templogFid);  % Close logfile on exit
        if closeStatus == 0  % if closed sucessfully...
            delete([baseLogName '_temp.txt'])  % ...remove the temporary logfile
        end
    end


    function xMoveAction
        updateView;
    end


    function yMoveAction
        updateView;
    end


    function zMoveAction
        updateView;
    end


    function a1MoveAction
        updateView;
    end


    function a2MoveAction
        updateView;
    end


    function a3MoveAction
        updateView;
    end

    function updateView
        xyz(1) = xSliderHandle.Value;
        xyz(2) = ySliderHandle.Value;
        xyz(3) = zSliderHandle.Value;
        angles(1) = a1SliderHandle.Value; % * pi/180;
        angles(2) = a2SliderHandle.Value; % * pi/180;
        angles(3) = a3SliderHandle.Value; % * pi/180;
        planeNormal(1) = cosd(angles(1))*sind(angles(2));
        planeNormal(2) = sind(angles(1))*sind(angles(2));
        planeNormal(3) = cosd(angles(2));
        postMessage(sprintf('Normal vector components: %.2f, %.2f, %.2f', planeNormal(1), planeNormal(2), planeNormal(3)))

        if not(isempty(volUint8)) && not(isempty(histologyImage))
            imslice = extractSlice(volUint8, xyz(1), xyz(2), xyz(3), planeNormal(1), planeNormal(2), planeNormal(3), ...
                max([size(volUint8, 1), size(volUint8, 2)])/2, zAxisFactor, angles);
            imshowpair(imslice, histologyShowImage, 'montage')
            colormap('gray');
        elseif not(isempty(volUint8))
            imslice = extractSlice(volUint8, xyz(1), xyz(2), xyz(3), planeNormal(1), planeNormal(2), planeNormal(3), ...
                max([size(volUint8, 1), size(volUint8, 2)])/2, zAxisFactor, angles);
            imagesc(imslice)
            colormap('gray');
        elseif not(isempty(histologyImage))
            imshow(histologyImage)
            colormap('gray');
        end
    end



    set(f, 'visible', 'on');

end
