function gui_main()
    % Create the GUI using Octave-compatible commands
    fig = figure('Name', 'Distillation Column GUI', 'Position', [100, 100, 800, 800]);

    % Input fields for energy balance
    uicontrol('Style', 'text', 'Position', [50, 740, 150, 20], 'String', 'Mdot Feed (kg/s):');
    input_mdot_feed = uicontrol('Style', 'edit', 'Position', [200, 740, 100, 20]);

    uicontrol('Style', 'text', 'Position', [50, 700, 150, 20], 'String', 'H Feed (kJ/kg):');
    input_h_feed = uicontrol('Style', 'edit', 'Position', [200, 700, 100, 20]);

    uicontrol('Style', 'text', 'Position', [50, 660, 150, 20], 'String', 'Mdot Distillate (kg/s):');
    input_mdot_distillate = uicontrol('Style', 'edit', 'Position', [200, 660, 100, 20]);

    uicontrol('Style', 'text', 'Position', [50, 620, 150, 20], 'String', 'H Distillate (kJ/kg):');
    input_h_distillate = uicontrol('Style', 'edit', 'Position', [200, 620, 100, 20]);

    uicontrol('Style', 'text', 'Position', [50, 580, 150, 20], 'String', 'Mdot Bottom (kg/s):');
    input_mdot_bottom = uicontrol('Style', 'edit', 'Position', [200, 580, 100, 20]);

    uicontrol('Style', 'text', 'Position', [50, 540, 150, 20], 'String', 'H Bottom (kJ/kg):');
    input_h_bottom = uicontrol('Style', 'edit', 'Position', [200, 540, 100, 20]);

    % Input fields for material balance
    uicontrol('Style', 'text', 'Position', [50, 500, 150, 20], 'String', 'Feed Flow Rate (F):');
    input_F = uicontrol('Style', 'edit', 'Position', [200, 500, 100, 20]);

    uicontrol('Style', 'text', 'Position', [50, 460, 150, 20], 'String', 'Feed Composition (x_F):');
    input_x_F = uicontrol('Style', 'edit', 'Position', [200, 460, 100, 20]);

    uicontrol('Style', 'text', 'Position', [50, 420, 150, 20], 'String', 'Distillate Composition (x_D):');
    input_x_D = uicontrol('Style', 'edit', 'Position', [200, 420, 100, 20]);

    uicontrol('Style', 'text', 'Position', [50, 380, 150, 20], 'String', 'Bottoms Composition (x_B):');
    input_x_B = uicontrol('Style', 'edit', 'Position', [200, 380, 100, 20]);

    % Input fields for VLE model
    uicontrol('Style', 'text', 'Position', [50, 340, 150, 20], 'String', 'Temperature (T °C):');
    input_T = uicontrol('Style', 'edit', 'Position', [200, 340, 100, 20]);

    uicontrol('Style', 'text', 'Position', [50, 300, 150, 20], 'String', 'Pressure (P mmHg):');
    input_P = uicontrol('Style', 'edit', 'Position', [200, 300, 100, 20]);

    uicontrol('Style', 'text', 'Position', [50, 260, 150, 20], 'String', 'Liquid Mole Fractions (X):');
    input_X = uicontrol('Style', 'edit', 'Position', [200, 260, 100, 20]);

    % Input fields for Antoine constants
    uicontrol('Style', 'text', 'Position', [50, 220, 150, 20], 'String', 'Antoine Constant A:');
    input_A = uicontrol('Style', 'edit', 'Position', [200, 220, 100, 20]);

    uicontrol('Style', 'text', 'Position', [50, 180, 150, 20], 'String', 'Antoine Constant B:');
    input_B = uicontrol('Style', 'edit', 'Position', [200, 180, 100, 20]);

    uicontrol('Style', 'text', 'Position', [50, 140, 150, 20], 'String', 'Antoine Constant C:');
    input_C = uicontrol('Style', 'edit', 'Position', [200, 140, 100, 20]);

    % Buttons to call models
    uicontrol('Style', 'pushbutton', 'Position', [50, 100, 200, 30], 'String', 'Run VLE Model', ...
        'Callback', @(src, event)run_vle_model());

    % Output area to display results
    uicontrol('Style', 'text', 'Position', [400, 740, 200, 20], 'String', 'Results:');
    output = uicontrol('Style', 'edit', 'Position', [400, 100, 350, 600], 'Max', 2, 'Enable', 'inactive');

    % Nested function to call the VLE model
    function run_vle_model()
        % Fetch inputs
        T = str2double(get(input_T, 'String'));
        P = str2double(get(input_P, 'String'));
        X = str2num(get(input_X, 'String')); %#ok<ST2NM>
        A = str2num(get(input_A, 'String')); %#ok<ST2NM>
        B = str2num(get(input_B, 'String')); %#ok<ST2NM>
        C = str2num(get(input_C, 'String')); %#ok<ST2NM>

        % Validate inputs
        if isempty(T) || isempty(P) || isempty(X) || isempty(A) || isempty(B) || isempty(C)
            set(output, 'String', 'Error: Please fill in all fields.');
            return;
        end

        if any(isnan([T, P])) || any(isnan(X)) || any(isnan(A)) || any(isnan(B)) || any(isnan(C))
            set(output, 'String', 'Error: Invalid numerical inputs.');
            return;
        end

        if length(A) ~= length(B) || length(B) ~= length(C) || length(A) ~= length(X)
            set(output, 'String', 'Error: Antoine constants and mole fractions must have the same length.');
            return;
        end

        % Call vle_model.m
        try
            [y, K] = vle_model(T, P, X, A, B, C);

            % Display results
            result_str = sprintf('Vapor Mole Fractions: [%s]\nEquilibrium Constants: [%s]', ...
                num2str(y, '%.2f '), num2str(K, '%.2f '));
            set(output, 'String', result_str);
        catch ME
            set(output, 'String', ['Error: ', ME.message]);
        end
    end
end
