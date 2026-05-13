clear; clc; close all;
SIG_LEVEL = 0.01;   

% DATASET 1- constant theft

meter_d1     = readtable('meter_d1_constant.csv');
collector_d1 = readtable('collector_d1_constant.csv');
truth_d1     = readtable('groundtruth_d1_constant.csv');

meter_ids = unique(meter_d1.MeterID);
N = length(meter_ids);
T = length(unique(meter_d1.TimeCode));

fprintf('DATASET 1 -Consumers N=%d | Time slots T=%d | DoF=%d\n\n', N, T, T-N);

P_d1 = zeros(T, N);
for n = 1:N
    rows      = meter_d1(meter_d1.MeterID == meter_ids(n), :);
    rows      = sortrows(rows, 'TimeCode');
    P_d1(:,n) = rows.Usage_kWh;
end

collector_d1 = sortrows(collector_d1, 'TimeCode');
c_d1 = collector_d1.Total_Supplied_kWh;
y_d1 = c_d1 - sum(P_d1, 2);

col_names  = arrayfun(@(n) sprintf('C%d',n), 1:N, 'UniformOutput', false);
P_d1_table = array2table(P_d1, 'VariableNames', col_names);
P_d1_table.y = y_d1;
lm_d1 = fitlm(P_d1_table, ['y ~ -1 + ' strjoin(col_names, ' + ')]);

a_d1  = lm_d1.Coefficients.Estimate;
SE_d1 = lm_d1.Coefficients.SE;
t_d1  = lm_d1.Coefficients.tStat;
p_d1  = lm_d1.Coefficients.pValue;

cls_d1 = cell(N, 1);
for n = 1:N
    if p_d1(n) < SIG_LEVEL
        if a_d1(n) > 0; cls_d1{n} = 'THIEF';
        else;            cls_d1{n} = 'FAULTY'; end
    else
        cls_d1{n} = 'Honest';
    end
end

fprintf('  LR-ETDM | DATASET 1: Constant Theft (h1)\n');
fprintf('  m<1 = theft (under-reporting) | m=1 = honest | m>1 = faulty (over-reporting)\n');
fprintf('%-9s  %-9s  %-9s  %-10s  %-10s  %-8s  %-14s  %-10s\n', ...
        'MeterID','a_n','SE(a_n)','t-stat','p-value','m','Detected','Truth');
fprintf('----------------------------------------------------------------------------------\n');

correct_d1 = 0;
for n = 1:N
    tr  = strrep(truth_d1.True_Label{truth_d1.MeterID == meter_ids(n)}, 'HONEST', 'Honest');
    det = cls_d1{n};
    if p_d1(n) < SIG_LEVEL; m_val = 1/(1+a_d1(n)); else; m_val = 1.0; end
    flag = '';
    if strcmp(det, tr); correct_d1 = correct_d1 + 1;
    else; flag = '  X  <-- WRONG'; end
    fprintf('%-9d  %-9.4f  %-9.4f  %-10.4f  %-10.4f  %-8.4f  %-14s  %-10s%s\n', ...
            meter_ids(n), a_d1(n), SE_d1(n), t_d1(n), p_d1(n), m_val, det, tr, flag);
end

fprintf('  Accuracy = %.1f%%  (%d / %d correct)\n', correct_d1/N*100, correct_d1, N);

% DATASET 2- Mixed Theft (h1 + h3) -- FAILS on h3

meter_d2     = readtable('meter_d2_mixed.csv');
collector_d2 = readtable('collector_d2_mixed.csv');
truth_d2     = readtable('groundtruth_d2_mixed.csv');

fprintf('DATASET 2 -- Consumers N=%d | Time slots T=%d | DoF=%d\n\n', N, T, T-N);

P_d2 = zeros(T, N);
for n = 1:N
    rows      = meter_d2(meter_d2.MeterID == meter_ids(n), :);
    rows      = sortrows(rows, 'TimeCode');
    P_d2(:,n) = rows.Usage_kWh;
end

collector_d2 = sortrows(collector_d2, 'TimeCode');
c_d2 = collector_d2.Total_Supplied_kWh;
y_d2 = c_d2 - sum(P_d2, 2);

P_d2_table   = array2table(P_d2, 'VariableNames', col_names);
P_d2_table.y = y_d2;
lm_d2 = fitlm(P_d2_table, ['y ~ -1 + ' strjoin(col_names, ' + ')]);

a_d2  = lm_d2.Coefficients.Estimate;
SE_d2 = lm_d2.Coefficients.SE;
t_d2  = lm_d2.Coefficients.tStat;
p_d2  = lm_d2.Coefficients.pValue;

cls_d2 = cell(N, 1);
for n = 1:N
    if p_d2(n) < SIG_LEVEL
        if a_d2(n) > 0; cls_d2{n} = 'THIEF';
        else;            cls_d2{n} = 'FAULTY'; end
    else
        cls_d2{n} = 'Honest';
    end
end

fprintf('  LR-ETDM | DATASET 2: Mixed Theft (h1 + h3)   <-- WILL FAIL on h3\n');
fprintf('  m<1 = theft (under-reporting) | m=1 = honest | m>1 = faulty (over-reporting)\n');
fprintf('%-9s  %-9s  %-9s  %-10s  %-10s  %-8s  %-14s  %-10s\n', ...
        'MeterID','a_n','SE(a_n)','t-stat','p-value','m','Detected','Truth');
fprintf('----------------------------------------------------------------------------------\n');

correct_d2 = 0;
for n = 1:N
    tr  = strrep(truth_d2.True_Label{truth_d2.MeterID == meter_ids(n)}, 'HONEST', 'Honest');
    det = cls_d2{n};
    if p_d2(n) < SIG_LEVEL; m_val = 1/(1+a_d2(n)); else; m_val = 1.0; end
    flag = '';
    if strcmp(det, tr); correct_d2 = correct_d2 + 1;
    else; flag = '  X  <-- WRONG'; end
    fprintf('%-9d  %-9.4f  %-9.4f  %-10.4f  %-10.4f  %-8.4f  %-14s  %-10s%s\n', ...
            meter_ids(n), a_d2(n), SE_d2(n), t_d2(n), p_d2(n), m_val, det, tr, flag);
end

%Plots

col_thief  = [0.80 0.15 0.15];   % Red
col_faulty = [0.15 0.40 0.75];   % Blue
col_honest = [0.20 0.60 0.35];   % Green
col_wrong  = [0.55 0.10 0.70];   % Purple

x_labels = arrayfun(@num2str, meter_ids, 'UniformOutput', false);

function bc = get_colors(cls, truth, meter_ids, ct, cf, ch, cw)
    N = length(meter_ids); bc = zeros(N,3);
    for n = 1:N
        tr  = strrep(truth.True_Label{truth.MeterID==meter_ids(n)}, 'HONEST', 'Honest');
        det = cls{n};
        if ~strcmp(det,tr);          bc(n,:) = cw;
        elseif strcmp(det,'THIEF');  bc(n,:) = ct;
        elseif strcmp(det,'FAULTY'); bc(n,:) = cf;
        else;                        bc(n,:) = ch; end
    end
end

bc_d1 = get_colors(cls_d1, truth_d1, meter_ids, col_thief, col_faulty, col_honest, col_wrong);
bc_d2 = get_colors(cls_d2, truth_d2, meter_ids, col_thief, col_faulty, col_honest, col_wrong);

figure('Name','LR-ETDM: Anomaly Coefficients D1 vs D2', ...
       'Color','white','Position',[30 420 1300 400]);

for ds = 1:2
    subplot(1,2,ds);
    if ds==1; av=a_d1; bcv=bc_d1; acv=correct_d1/N*100; truth=truth_d1;
    else;     av=a_d2; bcv=bc_d2; acv=correct_d2/N*100; truth=truth_d2; end

    bh = bar(1:N, av, 'FaceColor','flat');
    bh.CData = bcv;
    hold on;
    yline(0,'k-','LineWidth',1.5);
    for n = 1:N
        if p_d1(n) < SIG_LEVEL && ds==1
            ofs = 0.06*sign(av(n));
            text(n, av(n)+ofs, sprintf('%.3f',av(n)), ...
                 'HorizontalAlignment','center','FontSize',7.5, ...
                 'FontWeight','bold','Color',bcv(n,:));
        end
        tr = truth.True_Label{truth.MeterID==meter_ids(n)};
        if ~strcmp(tr,'HONEST')
            plot(n, min(av)-0.12,'k^','MarkerFaceColor','k','MarkerSize',6);
        end
    end
    hold off;

    dslabel = {'Dataset 1: Constant (h1)', 'Dataset 2: Mixed (h1+h3)  <-- FAILS'};
    title({dslabel{ds}, sprintf('Accuracy = %.1f%%', acv)}, ...
          'FontSize',11,'FontWeight','bold');
    xlabel('Meter ID','FontSize',10);
    ylabel('a_n','FontSize',11,'FontAngle','italic');
    xticks(1:N); xticklabels(x_labels); xtickangle(90);
    grid on; xlim([0 N+1]);

    hold on;
    hT=bar(NaN,'FaceColor',col_thief); hF=bar(NaN,'FaceColor',col_faulty);
    hH=bar(NaN,'FaceColor',col_honest); hW=bar(NaN,'FaceColor',col_wrong);
    hold off;
    legend([hT hF hH hW],{'Thief','Faulty','Honest','WRONG'}, ...
           'Location','northeast','FontSize',8);
end

sgtitle('LR-ETDM: Anomaly Coefficients  (triangles = truly dishonest consumers)', ...
        'FontSize',12,'FontWeight','bold');



