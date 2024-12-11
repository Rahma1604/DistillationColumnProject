function [D, B, isBalanced] = material_balance(F, x_F, x_D, x_B)
    % Material Balance for Distillation Process
    % Inputs:
    %   F: Feed flow rate (L/h)
    %   x_F: Mole fraction of component A in the feed
    %   x_D: Mole fraction of component A in the distillate
    %   x_B: Mole fraction of component A in the bottoms
    % Outputs:
    %   D: Distillate flow rate (L/h)
    %   B: Bottoms flow rate (L/h)
    %   isBalanced: True if the material balance holds, False otherwise

    % Calculate flow rates
    D = (F * (x_F - x_B)) / (x_D - x_B);
    B = F - D;

    % Check material balance
    balance_check = F * x_F; % Incoming material
    balance_out = D * x_D + B * x_B; % Outgoing material
    isBalanced = abs(balance_check - balance_out) < 1e-5;

    % Print results
    fprintf('Feed Flow Rate (F): %.2f L/h\n', F);
    fprintf('Distillate Flow Rate (D): %.2f L/h\n', D);
    fprintf('Bottoms Flow Rate (B): %.2f L/h\n', B);
    fprintf('Feed Composition (x_F): %.2f\n', x_F);
    fprintf('Distillate Composition (x_D): %.2f\n', x_D);
    fprintf('Bottoms Composition (x_B): %.2f\n', x_B);

    % Material balance verification
    if isBalanced
        disp('Material balance is correct!');
    else
        disp('Material balance is incorrect!');
    end
end
