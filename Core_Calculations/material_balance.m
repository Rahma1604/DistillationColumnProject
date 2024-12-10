% Inputs:
F = 1000; % Total flow rate of the feed (L/h)
x_F = 0.4; % Mole fraction of component A in the feed stream (fraction)
x_D = 0.9; % Mole fraction of component A in the distillate (vapor product) (fraction)
x_B = 0.1; % Mole fraction of component A in the bottoms (liquid product) (fraction)

% Calculate the resulting flows:
D = (F * (x_F - x_B)) / (x_D - x_B); % Distillate flow rate
B = F - D; % Bottoms flow rate

% Material balance calculations:
balance_check = F * x_F; % Incoming material (feed)
balance_out = D * x_D + B * x_B; % Outgoing material (distillate + bottoms)

% Display the results:
disp(['Feed flow rate (F): ', num2str(F), ' L/h']);
disp(['Distillate flow rate (D): ', num2str(D), ' L/h']);
disp(['Bottoms flow rate (B): ', num2str(B), ' L/h']);
disp(['Feed composition (x_F): ', num2str(x_F)]);
disp(['Distillate composition (x_D): ', num2str(x_D)]);
disp(['Bottoms composition (x_B): ', num2str(x_B)]);
disp(['Material balance check (incoming): ', num2str(balance_check)]);
disp(['Material balance check (outgoing): ', num2str(balance_out)]);

% Check if the material balance is correct:
if abs(balance_check - balance_out) < 1e-5
    disp('Material balance is correct!');
else
    disp('Material balance is incorrect!');
end
