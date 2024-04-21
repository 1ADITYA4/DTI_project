function state = observationSpace2(env, curPhase)
    % Observation space 2: (3*4 + 1 = 13)
    % Each road:
    %   - Head car distance to intersection
    %   - Head car velocity
    %   - Head car intention: right or left
    %   - Number of cars
    % Current signal phase

    state = [curPhase];

    for i = 1:env.N
        if ~isempty(env.network(i).Vehicles)
            car = headCar(env.network(i));
            dist = env.network(i).Length - car.getStationDistance();
            vel = car.getSpeed();
            intent = -1; % Default is turn left
            next_node = car.NextNode(1);
            
            if i == 1
                if next_node == env.network(7)
                    intent = 1; % Turn right
                end
            elseif i == 2
                if next_node == env.network(11)
                    intent = 1; % Turn right
                end
            elseif i == 3
                if next_node == env.network(9)
                    intent = 1; % Turn right
                end
            end
            
            num_cars = length(env.network(i).Vehicles);
            obs = [dist, vel, num_cars, intent];
        else
            obs = [env.network(i).Length, 0, 0, 0]; % No car
        end
        state = [state, obs];
    end

    car_low = [0, 0, 0, -1];
    car_high = [50, 15, 10, 1];
    low_limit = [0] + car_low * 3;
    high_limit = [2] + car_high * 3;

    state = (state - low_limit) ./ (high_limit - low_limit);
end

function head_car(net)
    cars = [car for car in net.Vehicles.MotionStrategy];
    index = head_car_index(net, cars);
    return cars[index];
end

function head_car_index(net, cars)
    if len(net.Vehicles) > 1:
        travel_distance = [car.get_station_distance() for car in cars];
        return max(enumerate(travel_distance), key=lambda x: x[1])[0];
    else:
        return 0;
end
