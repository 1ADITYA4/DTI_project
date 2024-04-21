function observation_space_1(env, cur_phase)
    % Observation space 1: (3*3 + 1 = 10)
    % Each road:
    %   - Head car distance to intersection
    %   - Head car velocity
    %   - Number of cars
    % Current signal phase

    state = [cur_phase];

    for i = 1:env.N
        if ~isempty(env.network(i).Vehicles)
            car = head_car(env.network(i));
            dist = env.network(i).Length - car.get_station_distance();
            vel = car.get_speed();
            num_cars = length(env.network(i).Vehicles);
            obs = [dist, vel, num_cars];
        else
            obs = [env.network(i).Length, 0, 0];
        end
        state = [state, obs];
    end

    car_low = [0, 0, 0];
    car_high = [50, 15, 10];
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
    if length(net.Vehicles) > 1:
        travel_distance = [car.get_station_distance() for car in cars];
        return max(enumerate(travel_distance), key=lambda x: x[1])[0];
    else
        return 0;
    end
end
