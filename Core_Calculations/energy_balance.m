function [Q] = energy_balance(mdot_feed, h_feed, mdot_distillate, h_distillate, mdot_bottom, h_bottom)
    % حساب موازنة الطاقة
    Q = (mdot_distillate * h_distillate + mdot_bottom * h_bottom) - (mdot_feed * h_feed);
end


% تعريف المدخلات
mdot_feed = 100;       % معدل تدفق التغذية (kg/s)
h_feed = 500;          % الإنثالبي للتغذية (kJ/kg)
mdot_distillate = 60;  % معدل المنتج العلوي (kg/s)
h_distillate = 800;    % الإنثالبي للمنتج العلوي (kJ/kg)
mdot_bottom = 40;      % معدل المنتج السفلي (kg/s)
h_bottom = 300;        % الإنثالبي للمنتج السفلي (kJ/kg)

% استدعاء الدالة
Q = energy_balance(mdot_feed, h_feed, mdot_distillate, h_distillate, mdot_bottom, h_bottom);

% عرض النتيجة
fprintf('الحرارة المطلوبة (Q) هي: %.2f kW\n', Q);
