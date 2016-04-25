function points = correct3d(setup, masksSuffix, VERBOSE)
  %
  
  % Prefixes for the data files
  imageFilename = setup.imageFilename;
  inputFilenamePrefix = setup.outputFilenamePrefix;
  downsampleFactor = 2;
  
  origo = setup.origo;
  R = setup.R;
  
  points = [];
  pointHandles = [];
  ax = gca;
  cla(ax);
  fig = gcf;
  
  implantPatch = visualizeImplant(ax, inputFilenamePrefix, masksSuffix, downsampleFactor, VERBOSE);
  
  set(implantPatch, 'ButtonDownFcn', @addPoint);
  rotate3d off;
  set(fig, 'KeyPressFcn', @delPoint);
  
  fprintf('Annotate 4 points on a line on the surface parallel to the implant direction (micro threads are upwards):\n');
  i=0;
  i=i+1; fprintf('  %d. The stop point of the micro valey, the reference point (rf).\n',i);
  i=i+1; fprintf('  %d. The first micro ridge above rf.\n',i);
  i=i+1; fprintf('  %d. 11 micro ridge higher than rf.\n',i);
  i=i+1; fprintf('  %d. 1 macro ridge lower than rf.\n',i);
  fprintf('Press ''r'' to toggle rotate, ''<backspace>'' to delete last point, ''q'' to save and continue.\n');
  
  while true
    k = waitforbuttonpress;
    if k == 1
      c = get(fig,'CurrentCharacter');
      if c == 'r'
        rotate3d;
      end
      if c == 'q'
        break;
      end
    end
  end
  
  function newVol = loadImage(imageFilename, VERBOSE)
    %
    if VERBOSE
      fprintf('  loading %s\n', imageFilename);
    end
    load(imageFilename, 'newVol'); % loads newVol
  end
  
  function p = visualizeImplant(ax, inputFilenamePrefix, masksSuffix, downsampleFactor, VERBOSE)
    %
    inputFilename = [inputFilenamePrefix, masksSuffix];
    
    if VERBOSE
      fprintf('  loading %s\n', inputFilename);
    end
    load(inputFilename, 'implant');
    
    if VERBOSE
      fprintf('  visualizing surface\n');
    end
    
    v = implant(1:downsampleFactor:size(implant, 1), 1:downsampleFactor:size(implant, 2), 1:downsampleFactor:size(implant, 3));
    tax = gca;
    axes(ax);
    p = patch(isosurface(v, 0.5));
    axes(tax);
    isonormals(v, p)
    p.FaceColor = 'red';
    p.EdgeColor = 'none';
    daspect([1 1 1])
    view(3)
    light('Position',[-1 -1 1],'Style','infinite')
    light('Position',[1 1 1],'Style','infinite')
    lighting phong
    set(p,'ambientstrength',0.1);
  end
  
  function addPoint(hObject,callbackdata)
    %
    x = callbackdata.IntersectionPoint;
    points(:,end+1) = downsampleFactor*(x([2,1,3])-1)+1; % We store in row, column form!
    hold on;
    pointHandles(end+1) = plot3(x(1),x(2),x(3),'ob');
    hold off
  end
  
  function delPoint(hObject,callbackdata)
    %
    k = callbackdata.Key;
    if strcmp(k,'backspace') && (size(points,2) > 0)
      points(:,end) = [];
      delete(pointHandles(end))
      pointHandles(end) = [];
    end
  end
end
