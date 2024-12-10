function [D, B, x_d, x_b] = gauss_seidel(F, z_f, x_d_init, x_b_init, tol, max_iter)
    % المدخلات:
    % F: معدل تدفق التغذية
    % z_f: تركيز المكون في التغذية
    % x_d_init: القيمة الابتدائية لتركيز المقطر
    % x_b_init: القيمة الابتدائية لتركيز السائل السفلي
    % tol: الحد الأقصى للخطأ المسموح به
    % max_iter: الحد الأقصى لعدد التكرارات

    % المخرجات:
    % D: معدل تدفق المقطر
    % B: معدل تدفق الجزء السفلي
    % x_d: تركيز المقطر
    % x_b: تركيز الجزء السفلي

    % قيم ابتدائية
    x_d = x_d_init;
    x_b = x_b_init;
    D = 0; % معدل تدفق المقطر)
    B = 0; % معدل تدفق الجزء السفلي

    % بدء التكرار
    for iter = 1:max_iter
        % حفظ القيم السابقة للتحقق من التقارب
        x_d_prev = x_d;
        x_b_prev = x_b;

        % حساب D و B (موازنة المادة)
        B = F * (z_f - x_d) / (x_b - x_d);
        D = F - B;

        % تحديث x_d و x_b (موازنة المكون)
        x_d = z_f; % تركيز المنتج العلوي يعتمد على المواصفات
        x_b = (F * z_f - D * x_d) / B;

        % حساب الخطأ
        error = max(abs([x_d - x_d_prev, x_b - x_b_prev]));
        if error < tol
            fprintf('الحل تقارب بعد %d تكرار.\n', iter);
            return;
        end
    end

    % إذا لم يتقارب
    warning('الحل لم يتقارب بعد %d تكرار. قد تحتاج إلى زيادة التكرارات أو تعديل القيم الابتدائية.', max_iter);
end

