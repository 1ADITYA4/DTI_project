classdef DrivingStrategy < driving.scenario.MotionStrategy & ...
        driving.scenario.mixin.PropertiesInitializableInConstructor
    %% Properties
    
    properties
        Scenario
        Data = struct('Time', [], ...
                      'Station', [], ...
                      'Speed', [], ...
                      'Node', Node.empty, ...
                      'UDStates', [], ...
                      'Position', []);
        NextNode = Node.empty % Vehicle's planned path
        UDStates = [] % User-defined states
        
        % Parameters
        DesiredSpeed = 10; % [m/s]
        ReactionTime = 0.8; % [s]
        
        % Car-following model
        CarFollowingModel = 'Gipps'; % Options: 'IDM', 'Gipps'
        
        % Flags
        StoreData = true; % Set to true to store time series data in Data structure
        StaticLaneKeeping = true; % Set to false to implement user-defined lateral control
    end
    
    properties (Dependent, Access = protected)
        % Vehicle States
        Position(3, 1) double {mustBeReal, mustBeFinite}
        Velocity(3, 1) double {mustBeReal, mustBeFinite}
        ForwardVector(3, 1) double {mustBeReal, mustBeFinite}
        Speed
    end
    
    properties (Access = protected)
        % Input States
        Acceleration(1, 1) double {mustBeReal, mustBeFinite} = 0
        AngularAcceleration(1, 1) double {mustBeReal, mustBeFinite} = 0
    end
    
    properties (Access = protected)
        % Position Dependent Variables
        Node = Node.empty;
        Station = [];
        
        % Environment Dependent Variables
        IsLeader = false;
        Leader = driving.scenario.Vehicle.empty;
        LeaderSpacing = nan;
    end
    
    %% Constructor
    methods
        function obj = DrivingStrategy(egoActor, varargin)
            obj@driving.scenario.MotionStrategy(egoActor);
            obj@driving.scenario.mixin.PropertiesInitializableInConstructor(varargin{:});
            egoActor.MotionStrategy = obj;
            obj.Scenario = egoActor.Scenario;
        end
    end
    
    %% Methods (Add your custom methods here)
    methods
        % Add your custom logic for lateral control, lane keeping, etc.
        % Example:
        % function ApplyLateralControl(obj)
        %     % Implement your lateral control strategy here
        %     % ...
        % end
    end
end
