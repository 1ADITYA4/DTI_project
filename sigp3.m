function phase = signalPhaseDesign3(action)
    % Signal phase design 3: Each phase has three lanes.
    % Args:
    %     action (int): Action index (0, 1, 2, or 3).
    % Returns:
    %     list[int]: Binary list representing the active lanes for the signal phase.

    if action == 0
        phase = [1, 0, 1, 0, 1, 0];
    elseif action == 1
        phase = [1, 0, 0, 1, 0, 0];
    elseif action == 2
        phase = [0, 1, 0, 0, 1, 0];
    elseif action == 3
        phase = [0, 0, 1, 0, 0, 1];
    end
end
