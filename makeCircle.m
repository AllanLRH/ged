function [circ] = makeCircle(imgSideLength, radius, centerXY)
%% makeCircle: Create a logical circle

    % Check that the entire circle will be within the image boundaries
    % Raise warning if it's not
    conditions = false(1, 4);
    conditions(1) = (centerXY(1) + radius) <= imgSideLength;
    conditions(2) = (centerXY(1) - radius) >= 1;
    conditions(3) = (centerXY(2) + radius) <= imgSideLength;
    conditions(4) = (centerXY(2) - radius) >= 1;
    if not(all(conditions))
        warning('Circle is out of image bounds.')
    end

    % Calculate the circle
    circ = false(imgSideLength, imgSideLength);
    for x = 1:imgSideLength
        for y = 1:imgSideLength
            if (x-centerXY(2))^2 + (y-centerXY(1))^2 <= radius^2
                circ(x, y) = 1;
            end
        end
    end

end
