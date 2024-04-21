function state = observationSpace1(env, curPhase)
    % Observation space 1: (3*3 + 1 = 10)
    % Each road:
    %   - Head car distance to intersection
    %   - Head car velocity
    %   - Number of cars
    % Current signal phase

    % Current signal phase
    state = [curPhase];

    % Observation for each road
    for i = 1:env.N
        if isempty(env.network(i).Vehicles)
            % If no car
            obs = [env.network(i).Length, 0, 0];
        else
            % Find the head car
            car = headCar(env.network(i));
            % Head car distance
            dist = env.network(i).Length - car.getStationDistance;
            % Head car velocity
            vel = car.getSpeed;
            % Number of cars
            numCars = length(env.network(i).Vehicles);
            obs = [dist, vel, numCars];
        end
        % Merge observations from each road
        state = [state, obs];
    end

    % Set up the lower and upper limits for distance, velocity, and number of cars
    carLow = [0, 0, 0];
    carHigh = [50, 15, 10];
    lowLimit = [0, carLow, carLow, carLow];
    highLimit = [2, carHigh, carHigh, carHigh];

    % Normalize the observation
    state = (state - lowLimit) ./ (highLimit - lowLimit);
end

function headcar = headCar(net)
    % Find the head car distance to the intersection
    cars = [net.Vehicles.MotionStrategy];
    index = headCarIndex(net, cars);
    headcar = cars(index);
end

function Index = headCarIndex(net, cars)
    % Find the index of the head car
    if length(net.Vehicles) > 1
        travelDistance = [c.getStationDistance() for c in cars];
        [~, Index] = max(enumerate(travelDistance), key=lambda x: x[1]);
    else
        Index = 1;
    end
end
