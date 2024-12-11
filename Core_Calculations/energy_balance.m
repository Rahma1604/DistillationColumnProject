function [Q] = energy_balance(mdot_feed, h_feed, mdot_distillate, h_distillate, mdot_bottom, h_bottom)
    % حساب موازنة الطاقة
    Q = (mdot_distillate * h_distillate + mdot_bottom * h_bottom) - (mdot_feed * h_feed);
end




% استدعاء الدالة
Q = energy_balance(mdot_feed, h_feed, mdot_distillate, h_distillate, mdot_bottom, h_bottom);

% عرض النتيجة
fprintf('الحرارة المطلوبة (Q) هي: %.2f kW\n', Q);
