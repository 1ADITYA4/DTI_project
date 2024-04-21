function phase = signalPhaseDesign2(action)
    % Signal phase design 2: Each phase has three lanes.
    % Args:
    %     action (int): Action index (0, 1, or 2).
    % Returns:
    %     list[int]: Binary list representing the active lanes for the given action.

    if action == 0
        phase = [1, 0, 1, 1, 0, 0];
    elseif action == 1
        phase = [1, 1, 0, 0, 1, 0];
    elseif action == 2
        phase = [0, 0, 1, 0, 1, 1];
    end
end
