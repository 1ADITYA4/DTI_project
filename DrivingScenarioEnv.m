classdef DrivingScenarioEnv < rl.env.MATLABEnvironment
    % Copyright 2020 The MathWorks, Inc.
    % MYENVIRONMENT: Template for defining a custom environment in MATLAB.

    properties
        scenario
        network
        traffic
        cars
        state
        driver
        InjectionRate
        TurnRatio
        N = 3 % number of roads
        phaseDuration = 50 % time duration for each phase
        T
    end

    properties
        clearingPhase = false % simulation doesn't have yellow light
        clearingPhaseTime = 0
        TrafficSignalDesign
        ObservationSpaceDesign
    end

    properties
        rewardForPass = 0
        vehicleEnterJunction % keep record of cars passing the intersection
        hitPenalty = 20
        penaltyForFreqSwitch = 1
        safeDistance = 2.25 % check collision
        slowSpeedThreshold = 3.5 % check whether car is waiting
    end

    properties
        recordVid = false
        vid
    end

    properties
        discrete_action = [0 1 2];
        dim = 10;
    end

    properties (Access = protected)
        IsDone = false
    end

    %% Necessary Methods
    methods
        function this = DrivingScenarioEnv()
            % Initialize Observation settings
            ObservationInfo = rlNumericSpec([10, 1]); % # of state
            ObservationInfo.Name = 'real-time traffic information';
            ObservationInfo.Description = '';

            % Initialize action settings
            ActionInfo = rlFiniteSetSpec([0 1 2]); % three phases
            ActionInfo.Name = 'traffic signal phases';

            % The following line implements built-in functions of the RL environment
            this = this@rl.env.MATLABEnvironment(ObservationInfo, ActionInfo);
        end

        function [state, Reward, IsDone, LoggedSignals] = step(this, action)
            % Implement your step logic here
            % ...
        end

        function initialObservation = reset(this)
            % Implement your reset logic here
            % ...
        end

        function IsDone = isDone(this)
            % Implement your termination condition here
            % ...
        end
    end
end
