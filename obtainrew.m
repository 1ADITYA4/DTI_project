function reward = obtainReward(this, phase)
    % Calculate the reward for the RL agent based on various components.
    % Args:
    %     this: The RL environment.
    %     phase: Current signal phase.
    % Returns:
    %     float: The computed reward.

    reward = 0;
    driver = [];

    for i = 1:this.N
        if ~isempty(this.network(i).Vehicles)
            driver = [driver, this.network(i).Vehicles.MotionStrategy];
        end
    end

    if isempty(driver)
        return;
    end

    % Component 2: Waiting time (cars with speed below threshold)
    for car = driver
        speed = car.getSpeed();
        reward = reward - sum(speed < this.slowSpeedThreshold) * this.scenario.SampleTime;
    end

    % Component 3: Maximize cars' speed
    reward = reward + sum(car.getSpeed() for car in driver) * 0.01;

    % Component 4: Reward for cars entering the intersection
    for i = 7:12
        if ~isempty(this.network(i).Vehicles)
            for car = this.network(i).Vehicles
                if car not in this.vehicleEnterJunction
                    reward = reward + this.rewardForPass;
                    this.vehicleEnterJunction = [this.vehicleEnterJunction, car];
                end
            end
        end
    end
end
