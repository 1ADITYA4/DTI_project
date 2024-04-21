function phase = signalPhaseDesign1(action)
    % Signal phase design 1: Each phase has two lanes.
    % Args:
    %     action (int): Action index (0, 1, or 2).
    % Returns:
    %     list[int]: Binary list representing the active lanes for the signal phase.

    if action == 0
        phase = [0, 0, 1, 1, 0, 0];
    elseif action == 1
        phase = [1, 1, 0, 0, 0, 0];
    elseif action == 2
        phase = [0, 0, 0, 0, 1, 1];
    end
end
