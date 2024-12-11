function gui_main()
    % Create the GUI figure
    fig = figure('Name', 'Distillation Column GUI', 'Position', [100, 100, 800, 600]);

    % Adjusted positions to fit within 800x600 resolution
    % Energy balance inputs
    uicontrol('Style', 'text', 'Position', [20, 550, 150, 20], 'String', 'Mdot Feed (kg/s):');
    input_mdot_feed = uicontrol('Style', 'edit', 'Position', [180, 550, 100, 20]);

    uicontrol('Style', 'text', 'Position', [20, 520, 150, 20], 'String', 'H Feed (kJ/kg):');
    input_h_feed = uicontrol('Style', 'edit', 'Position', [180, 520, 100, 20]);

    uicontrol('Style', 'text', 'Position', [20, 490, 150, 20], 'String', 'Mdot Distillate (kg/s):');
    input_mdot_distillate = uicontrol('Style', 'edit', 'Position', [180, 490, 100, 20]);

    uicontrol('Style', 'text', 'Position', [20, 460, 150, 20], 'String', 'H Distillate (kJ/kg):');
    input_h_distillate = uicontrol('Style', 'edit', 'Position', [180, 460, 100, 20]);

    uicontrol('Style', 'text', 'Position', [20, 430, 150, 20], 'String', 'Mdot Bottom (kg/s):');
    input_mdot_bottom = uicontrol('Style', 'edit', 'Position', [180, 430, 100, 20]);

    uicontrol('Style', 'text', 'Position', [20, 400, 150, 20], 'String', 'H Bottom (kJ/kg):');
    input_h_bottom = uicontrol('Style', 'edit', 'Position', [180, 400, 100, 20]);

    % Material balance inputs
    uicontrol('Style', 'text', 'Position', [20, 370, 150, 20], 'String', 'Feed Flow Rate (F):');
    input_F = uicontrol('Style', 'edit', 'Position', [180, 370, 100, 20]);

    uicontrol('Style', 'text', 'Position', [20, 340, 150, 20], 'String', 'Feed Composition (x_F):');
    input_x_F = uicontrol('Style', 'edit', 'Position', [180, 340, 100, 20]);

    uicontrol('Style', 'text', 'Position', [20, 310, 150, 20], 'String', 'Distillate Composition (x_D):');
    input_x_D = uicontrol('Style', 'edit', 'Position', [180, 310, 100, 20]);

    uicontrol('Style', 'text', 'Position', [20, 280, 150, 20], 'String', 'Bottoms Composition (x_B):');
    input_x_B = uicontrol('Style', 'edit', 'Position', [180, 280, 100, 20]);

    % VLE model inputs
    uicontrol('Style', 'text', 'Position', [20, 250, 150, 20], 'String', 'Temperature (T °C):');
    input_T = uicontrol('Style', 'edit', 'Position', [180, 250, 100, 20]);

    uicontrol('Style', 'text', 'Position', [20, 220, 150, 20], 'String', 'Pressure (P mmHg):');
    input_P = uicontrol('Style', 'edit', 'Position', [180, 220, 100, 20]);

    uicontrol('Style', 'text', 'Position', [20, 190, 150, 20], 'String', 'Liquid Mole Fractions (X):');
    input_X = uicontrol('Style', 'edit', 'Position', [180, 190, 100, 20]);

    % Antoine constants inputs
    uicontrol('Style', 'text', 'Position', [20, 160, 150, 20], 'String', 'Antoine Constant A:');
    input_A = uicontrol('Style', 'edit', 'Position', [180, 160, 100, 20]);

    uicontrol('Style', 'text', 'Position', [20, 130, 150, 20], 'String', 'Antoine Constant B:');
    input_B = uicontrol('Style', 'edit', 'Position', [180, 130, 100, 20]);

    uicontrol('Style', 'text', 'Position', [20, 100, 150, 20], 'String', 'Antoine Constant C:');
    input_C = uicontrol('Style', 'edit', 'Position', [180, 100, 100, 20]);

    % Buttons for models and plots
    uicontrol('Style', 'pushbutton', 'Position', [300, 550, 200, 30], 'String', 'Run VLE Model', ...
        'Callback', @(src, event)run_vle_model());
    uicontrol('Style', 'pushbutton', 'Position', [300, 500, 200, 30], 'String', 'Plot Concentration Profile', ...
        'Callback', @(src, event)plot_concentration_profile());
    uicontrol('Style', 'pushbutton', 'Position', [300, 450, 200, 30], 'String', 'Plot Temperature Profile', ...
        'Callback', @(src, event)plot_temperature_profile());
    uicontrol('Style', 'pushbutton', 'Position', [300, 400, 200, 30], 'String', 'Plot Energy Balance', ...
        'Callback', @(src, event)plot_energy_balance());
    uicontrol('Style', 'pushbutton', 'Position', [300, 350, 200, 30], 'String', 'Plot Material Balance', ...
        'Callback', @(src, event)plot_material_balance());

    % Output area for results
    uicontrol('Style', 'text', 'Position', [530, 550, 100, 20], 'String', 'Results:');
    output = uicontrol('Style', 'edit', 'Position', [530, 250, 250, 280], 'Max', 2, 'Enable', 'inactive');

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

    % Nested functions to handle plotting
  function plot_concentration_profile()
    % جلب القيم المدخلة
    feed_composition = str2double(get(input_x_F, 'String'));
    distillate_composition = str2double(get(input_x_D, 'String'));
    bottoms_composition = str2double(get(input_x_B, 'String'));

    % التحقق من المدخلات
    if isnan(feed_composition) || isnan(distillate_composition) || isnan(bottoms_composition)
        set(output, 'String', 'Error: Please enter valid numerical compositions.');
        return;
    end

    % التأكد من أن القيم بين 0 و 1
    if any([feed_composition, distillate_composition, bottoms_composition] < 0 | ...
            [feed_composition, distillate_composition, bottoms_composition] > 1)
        set(output, 'String', 'Error: Compositions must be between 0 and 1.');
        return;
    end

    % توليد بيانات التركيز بناءً على المدخلات
    stages = 0:0.2:1;  % 6 قيم
    concentration_profile = [feed_composition, distillate_composition, bottoms_composition, bottoms_composition, distillate_composition, feed_composition];  % 6 قيم

    % التأكد من تطابق طول المصفوفات
    if length(stages) ~= length(concentration_profile)
        set(output, 'String', 'Error: Mismatch in the length of stages and concentration profile.');
        return;
    end

    % طباعة القيم للتحقق
    disp(concentration_profile);

    % رسم الجراف
    figure;
    plot(stages, concentration_profile, '-o');
    title('Concentration Profile');
    xlabel('Stage');
    ylabel('Composition');
end



    function plot_temperature_profile()
        % Generate temperature profile based on simple interpolation
        feed_temperature = str2double(get(input_T, 'String'));  % Assuming T is feed temperature
        boiling_point = 100;  % Example boiling point of the component
        stages = 0:0.2:1;
        temperature_profile = linspace(feed_temperature, boiling_point, length(stages));

        % Plot temperature profile
        figure;
        plot(stages, temperature_profile, '-o');
        title('Temperature Profile');
        xlabel('Stage');
        ylabel('Temperature (°C)');
    end

    function plot_energy_balance()
        % Fetch enthalpy and flow rates
        mdot_feed = str2double(get(input_mdot_feed, 'String'));
        h_feed = str2double(get(input_h_feed, 'String'));
        mdot_distillate = str2double(get(input_mdot_distillate, 'String'));
        h_distillate = str2double(get(input_h_distillate, 'String'));
        mdot_bottom = str2double(get(input_mdot_bottom, 'String'));
        h_bottom = str2double(get(input_h_bottom, 'String'));

        % Energy balance calculations (simple form)
        total_feed_energy = mdot_feed * h_feed;
        total_distillate_energy = mdot_distillate * h_distillate;
        total_bottom_energy = mdot_bottom * h_bottom;

        % Energy balance at different stages
        energy_balance = [total_feed_energy, total_distillate_energy, total_bottom_energy];

        % Plot energy balance
        figure;
        plot([1, 2, 3], energy_balance, '-o');
        title('Energy Balance');
        xlabel('Stage');
        ylabel('Energy (kJ/s)');
    end

    function plot_material_balance()
        % Fetch flow rates
        mdot_feed = str2double(get(input_mdot_feed, 'String'));
        mdot_distillate = str2double(get(input_mdot_distillate, 'String'));
        mdot_bottom = str2double(get(input_mdot_bottom, 'String'));

        % Material balance calculations
        material_balance = [mdot_feed, mdot_distillate, mdot_bottom];

        % Plot material balance
        figure;
        plot([1, 2, 3], material_balance, '-o');
        title('Material Balance');
        xlabel('Stage');
        ylabel('Flow Rate (kg/s)');
    end
end
