% Copyright 2020 The MathWorks, Inc.
% Author: xiangxuezhao@gmail.com
% Last modified: 08-27-2020

% Add OpenTrafficLab to the path
folderName = fullfile(cd, 'OpenTrafficLab');
addpath(folderName)

%% Step 1: Create RL environment from MATLAB template
env = DrivingScenarioEnv;

%% Specify traffic problem formulation
% Specify action space
env.TrafficSignalDesign = 1; % Options: 1, 2, 3
SignalPhaseDim = 3; % Dimension of signal phase (3 for designs 1 and 2, 4 for design 3)
env.phaseDuration = 50;
env.clearingPhase = true;
env.clearingPhaseTime = 5;

% Specify observation space
env.ObservationSpaceDesign = 1; % Options: 1, 2

% Specify reward parameters
slowSpeedThreshold = 3.5; % Car speed below this threshold is treated as waiting at the intersection
penaltyForFreqSwitch = 1; % Penalty for frequent/unnecessary signal phase switches
env.hitPenalty = 20; % Penalty for car collision
env.safeDistance = 2.25; % Safe distance for cars
env.rewardForPass = 10; % Reward for cars passing the intersection

% Obtain observation and action info
obsInfo = getObservationInfo(env);
actInfo = getActionInfo(env);

%% Step 3: Create DQN agent
% Policy representation by neural network
layers = [
    imageInputLayer([obsInfo.Dimension(1) 1 1], "Name", "observations", "Normalization", "none")
    fullyConnectedLayer(256, "Name", "obs_fc1")
    reluLayer("Name", "obs_relu1")
    fullyConnectedLayer(256, "Name", "obs_fc2")
    reluLayer("Name", "obs_relu2")
    fullyConnectedLayer(SignalPhaseDim, "Name", "Q")
];

lgraph = layerGraph(layers);

% Create critic function
criticOpts = rlRepresentationOptions('LearnRate', 5e-03, 'GradientThreshold', 1);
criticOpts.Optimizer = 'sgdm';
criticOpts.UseDevice = 'cpu';
critic = rlQValueRepresentation(lgraph, obsInfo, actInfo, 'Observation', {'observations'}, criticOpts);

% Agent options
agentOpts = rlDQNAgentOptions;
agentOpts.EpsilonGreedyExploration.EpsilonDecay = 1e-4;
agentOpts.DiscountFactor = 0.99;
agentOpts.TargetUpdateFrequency = 1;

% Create agent
agent = rlDQNAgent(critic, agentOpts);

%% Step 4: Train agent
% Specify training options
trainOpts = rlTrainingOptions;
trainOpts.MaxEpisodes = 2000;
trainOpts.MaxStepsPerEpisode = 1000;
trainOpts.StopTrainingCriteria = "AverageReward";
trainOpts.StopTrainingValue = 550;
trainOpts.ScoreAveragingWindowLength = 5;
trainOpts.SaveAgentCriteria = "EpisodeReward";
trainOpts.SaveAgentValue = 800;
trainOpts.SaveAgentDirectory = "savedAgents";
trainOpts.UseParallel = false;
trainOpts.ParallelizationOptions.Mode = "async";
trainOpts.ParallelizationOptions.DataToSendFromWorkers = "experiences";
trainOpts.ParallelizationOptions.StepsUntilDataIsSent = 30;
trainOpts.ParallelizationOptions.WorkerRandomSeeds = -1;
trainOpts.Verbose = false;
trainOpts.Plots = "training-progress";

% Train the agent or load an existing trained agent
doTraining = false;

if doTraining
    % Train the agent
    trainingInfo = train(agent, env, trainOpts);
else
    % Load the pretrained agent for the example
    folderName = cd; % Change current folder
    folderName = fullfile(folderName, 'savedAgents');
    filename = strcat('TjunctionDQNAgentDesign', num2str(env.TrafficSignalDesign), '.mat');
    file = fullfile(folderName, filename);
    load(file);
end

%% Step 5: Simulate agent
simOpts = rlSimulationOptions('MaxSteps', 1000);
experience = sim(env, agent, simOpts);
totalReward = sum(experience.Reward);
