function IsHit = checkCollision(this)
    % Check for collisions between vehicles within the intersection.

    driver = [];
    network = this.network;
    IsHit = false;

    % Get pairwise distance between all cars within the intersection
    for i = 7:size(network, 2)
        if ~isempty(network(i).Vehicles)
            driver = [driver, network(i).Vehicles.MotionStrategy];
        end
    end

    % Find whether there are cars with distance below the threshold
    if length(driver) > 1
        distances = [driver.getStationDistance() for driver in drivers];
        if min(distances) < this.safeDistance
            IsHit = true;
        end
    end

    % Visualization (optional)
    % if IsHit
    %     disp('OMG Car Collision!!');
    %     disp(driver.getPosition());
    % end
end
