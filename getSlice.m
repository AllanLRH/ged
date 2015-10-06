function imgSlice = getSlice(vol, rotateDirection, angle, height, planePoints, planeOrInterpOut)
    if not((strcmpi(planeOrInterpOut, 'interp') || strcmpi(planeOrInterpOut, 'plane')))
        error('Last argument to imgSlice must be ''plane'' or ''interp''')
    end

    % Inspired by example two in http://se.mathworks.com/help/matlab/ref/slice.html
    [x, y, z] = meshgrid(linspace(-1, 1, size(vol, 1)), linspace(-1, 1, size(vol, 2)), linspace(-1, 1, size(vol, 3)));
    hsp = surf(linspace(-1, 1, planePoints), linspace(-1, 1, planePoints), zeros(planePoints) + 2*height-1);
    upperLim = 1;
    lowerLim = -1*upperLim;
    xlim([lowerLim upperLim]);
    ylim([lowerLim upperLim]);
    zlim([lowerLim upperLim]);
    rotate(hsp, rotateDirection, angle);
    xd = hsp.XData;
    yd = hsp.YData;
    zd = hsp.ZData;
    shading flat
    xlim([lowerLim upperLim]);
    ylim([lowerLim upperLim]);
    zlim([lowerLim upperLim]);
    view(3)
    xlabel(1); ylabel(2); zlabel(3);
    s = slice(x, y, z, vol, xd, yd, zd);
    if strcmpi(planeOrInterpOut, 'plane')
        imgSlice = zeros(planePoints, planePoints, 3);
        imgSlice(1) = s.XData;
        imgSlice(2) = s.YData;
        imgSlice(3) = s.ZData;
    else
        imgSlice = s.CData;
    end
end
