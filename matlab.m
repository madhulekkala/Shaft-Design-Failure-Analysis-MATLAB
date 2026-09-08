clc;
clear;
close all;

%% ============================================================
%       SHAFT DESIGN & FAILURE ANALYSIS USING MATLAB
%       Combined Bending + Torsion + Fatigue Analysis
% =============================================================

%% 1. INPUT PARAMETERS

P = 10;                 % Power transmitted (kW)
N = 1000;               % Shaft speed (RPM)

L = 500;                % Shaft length (mm)

% Applied transverse load
F = 3000;               % Load (N)
a = 200;                % Load position from left bearing (mm)

% Material properties - AISI 1045 steel
Sy  = 530;              % Yield strength (MPa)
Sut = 625;              % Ultimate tensile strength (MPa)

% Design factor of safety
n_required = 2;

% Endurance limit
Se = 0.5*Sut;           % Approximate unmodified endurance strength (MPa)

% Diameter search range
d_range = 10:0.1:100;   % Diameter (mm)


%% 2. TORQUE CALCULATION

% Convert power from kW to W
P_W = P*1000;

% Torque equation:
% P = 2*pi*N*T/60

T = (60*P_W)/(2*pi*N);      % N-m
T_Nmm = T*1000;             % N-mm


%% 3. BEARING REACTION CALCULATION

% Simply supported shaft with point load F
%
% RA + RB = F
%
% Taking moment about A:
%
% RB*L = F*a

RB = (F*a)/L;
RA = F - RB;


%% 4. SHEAR FORCE AND BENDING MOMENT

x = linspace(0,L,1000);

V = zeros(size(x));
M = zeros(size(x));

for i = 1:length(x)

    if x(i) < a
        V(i) = RA;
        M(i) = RA*x(i);
    else
        V(i) = RA - F;
        M(i) = RA*x(i) - F*(x(i)-a);
    end

end


%% 5. MAXIMUM BENDING MOMENT

[M_max,index_M] = max(abs(M));

x_Mmax = x(index_M);


%% 6. STRESS CALCULATIONS FOR DIFFERENT DIAMETERS

sigma_b = zeros(size(d_range));
tau = zeros(size(d_range));
sigma_vm = zeros(size(d_range));
sigma_1 = zeros(size(d_range));
sigma_2 = zeros(size(d_range));
tau_max = zeros(size(d_range));

for i = 1:length(d_range)

    d = d_range(i);

    % Bending stress
    sigma_b(i) = (32*M_max)/(pi*d^3);

    % Torsional shear stress
    tau(i) = (16*T_Nmm)/(pi*d^3);

    % Von Mises stress
    sigma_vm(i) = sqrt(sigma_b(i)^2 + 3*tau(i)^2);

    % Principal stresses
    sigma_1(i) = (sigma_b(i)/2) + ...
                 sqrt((sigma_b(i)/2)^2 + tau(i)^2);

    sigma_2(i) = (sigma_b(i)/2) - ...
                 sqrt((sigma_b(i)/2)^2 + tau(i)^2);

    % Maximum shear stress
    tau_max(i) = sqrt((sigma_b(i)/2)^2 + tau(i)^2);

end


%% 7. FACTOR OF SAFETY

FOS_VM = Sy ./ sigma_vm;

% Tresca factor of safety
FOS_Tresca = (Sy/2) ./ tau_max;


%% 8. REQUIRED DIAMETER BASED ON VON MISES

index_safe_VM = find(FOS_VM >= n_required,1);

if isempty(index_safe_VM)

    d_safe_VM = NaN;

else

    d_safe_VM = d_range(index_safe_VM);

end


%% 9. REQUIRED DIAMETER BASED ON TRESCA

index_safe_Tresca = find(FOS_Tresca >= n_required,1);

if isempty(index_safe_Tresca)

    d_safe_Tresca = NaN;

else

    d_safe_Tresca = d_range(index_safe_Tresca);

end


%% 10. SELECT GOVERNING DIAMETER

if isnan(d_safe_VM)

    d_design = NaN;

elseif isnan(d_safe_Tresca)

    d_design = d_safe_VM;

else

    d_design = max(d_safe_VM,d_safe_Tresca);

end


%% 11. STRESSES AT DESIGN DIAMETER

if ~isnan(d_design)

    sigma_b_design = (32*M_max)/(pi*d_design^3);

    tau_design = (16*T_Nmm)/(pi*d_design^3);

    sigma_vm_design = sqrt( ...
        sigma_b_design^2 + 3*tau_design^2);

    sigma_1_design = ...
        (sigma_b_design/2) + ...
        sqrt((sigma_b_design/2)^2 + tau_design^2);

    sigma_2_design = ...
        (sigma_b_design/2) - ...
        sqrt((sigma_b_design/2)^2 + tau_design^2);

    tau_max_design = ...
        sqrt((sigma_b_design/2)^2 + tau_design^2);

    FOS_VM_design = Sy/sigma_vm_design;

    FOS_Tresca_design = ...
        (Sy/2)/tau_max_design;

else

    sigma_b_design = NaN;
    tau_design = NaN;
    sigma_vm_design = NaN;
    sigma_1_design = NaN;
    sigma_2_design = NaN;
    tau_max_design = NaN;
    FOS_VM_design = NaN;
    FOS_Tresca_design = NaN;

end


%% 12. BASIC FATIGUE ANALYSIS

% Assumption:
% Bending stress is completely reversed.
% Therefore:
%
% Alternating stress = bending stress
% Mean stress = torsional equivalent stress
%
% This is a simplified preliminary fatigue model.

sigma_a = sigma_b_design;

% Convert torsional shear stress to equivalent normal stress
sigma_m = sqrt(3)*tau_design;

% Goodman equation:
%
% sigma_a/Se + sigma_m/Sut <= 1/n

fatigue_usage = ...
    (sigma_a/Se) + (sigma_m/Sut);

FOS_Goodman = 1/fatigue_usage;


%% 13. FATIGUE DESIGN STATUS

if FOS_Goodman >= n_required

    fatigue_status = "SAFE";

else

    fatigue_status = "UNSAFE";

end


%% 14. STATIC DESIGN STATUS

if FOS_VM_design >= n_required && ...
   FOS_Tresca_design >= n_required

    static_status = "SAFE";

else

    static_status = "UNSAFE";

end


%% 15. DISPLAY RESULTS

fprintf('\n');
fprintf('====================================================\n');
fprintf('       SHAFT DESIGN & FAILURE ANALYSIS\n');
fprintf('====================================================\n');

fprintf('\nINPUT PARAMETERS\n');
fprintf('----------------------------------------------------\n');

fprintf('Power                  : %.2f kW\n',P);
fprintf('Speed                  : %.2f RPM\n',N);
fprintf('Shaft Length           : %.2f mm\n',L);
fprintf('Applied Load           : %.2f N\n',F);
fprintf('Load Position          : %.2f mm\n',a);

fprintf('\nMATERIAL PROPERTIES\n');
fprintf('----------------------------------------------------\n');

fprintf('Material               : AISI 1045 Steel\n');
fprintf('Yield Strength         : %.2f MPa\n',Sy);
fprintf('Ultimate Strength      : %.2f MPa\n',Sut);
fprintf('Endurance Strength     : %.2f MPa\n',Se);

fprintf('\nLOADING RESULTS\n');
fprintf('----------------------------------------------------\n');

fprintf('Transmitted Torque     : %.2f N-m\n',T);
fprintf('Left Bearing Reaction  : %.2f N\n',RA);
fprintf('Right Bearing Reaction : %.2f N\n',RB);
fprintf('Maximum Bending Moment : %.2f N-mm\n',M_max);
fprintf('Location of Mmax       : %.2f mm\n',x_Mmax);

fprintf('\nDESIGN RESULTS\n');
fprintf('----------------------------------------------------\n');

fprintf('Required FOS            : %.2f\n',n_required);

fprintf('Minimum Diameter - VM   : %.2f mm\n',d_safe_VM);
fprintf('Minimum Diameter - Tresca: %.2f mm\n',d_safe_Tresca);

fprintf('Governing Diameter      : %.2f mm\n',d_design);

fprintf('\nSTRESS RESULTS\n');
fprintf('----------------------------------------------------\n');

fprintf('Bending Stress          : %.2f MPa\n',sigma_b_design);
fprintf('Torsional Shear Stress  : %.2f MPa\n',tau_design);
fprintf('Von Mises Stress        : %.2f MPa\n',sigma_vm_design);

fprintf('Principal Stress 1      : %.2f MPa\n',sigma_1_design);
fprintf('Principal Stress 2      : %.2f MPa\n',sigma_2_design);

fprintf('Maximum Shear Stress    : %.2f MPa\n',tau_max_design);

fprintf('\nSAFETY FACTORS\n');
fprintf('----------------------------------------------------\n');

fprintf('Von Mises FOS            : %.2f\n',FOS_VM_design);
fprintf('Tresca FOS               : %.2f\n',FOS_Tresca_design);
fprintf('Goodman Fatigue FOS      : %.2f\n',FOS_Goodman);

fprintf('\nDESIGN STATUS\n');
fprintf('----------------------------------------------------\n');

fprintf('Static Design            : %s\n',static_status);
fprintf('Fatigue Design           : %s\n',fatigue_status);

fprintf('\n====================================================\n');


%% 16. SHEAR FORCE DIAGRAM

figure;

plot(x,V,'LineWidth',2);

xlabel('Position Along Shaft (mm)');
ylabel('Shear Force (N)');
title('Shear Force Diagram');

grid on;


%% 17. BENDING MOMENT DIAGRAM

figure;

plot(x,M,'LineWidth',2);

xlabel('Position Along Shaft (mm)');
ylabel('Bending Moment (N-mm)');
title('Bending Moment Diagram');

grid on;


%% 18. VON MISES STRESS VS DIAMETER

figure;

plot(d_range,sigma_vm,'LineWidth',2);

hold on;

yline(Sy/n_required,'--');

xline(d_design,'--');

xlabel('Shaft Diameter (mm)');
ylabel('Von Mises Stress (MPa)');
title('Von Mises Stress vs Shaft Diameter');

legend('Von Mises Stress',...
       'Allowable Stress',...
       'Design Diameter');

grid on;


%% 19. FACTOR OF SAFETY VS DIAMETER

figure;

plot(d_range,FOS_VM,'LineWidth',2);

hold on;

yline(n_required,'--');

xline(d_design,'--');

xlabel('Shaft Diameter (mm)');
ylabel('Factor of Safety');
title('Factor of Safety vs Shaft Diameter');

legend('Von Mises FOS',...
       'Required FOS',...
       'Design Diameter');

grid on;


%% 20. BENDING AND TORSIONAL STRESS

figure;

plot(d_range,sigma_b,'LineWidth',2);

hold on;

plot(d_range,tau,'LineWidth',2);

xlabel('Shaft Diameter (mm)');
ylabel('Stress (MPa)');
title('Bending and Torsional Stress vs Diameter');

legend('Bending Stress',...
       'Torsional Shear Stress');

grid on;


%% 21. FAILURE THEORY COMPARISON

figure;

bar([FOS_VM_design FOS_Tresca_design FOS_Goodman]);

xticklabels({'Von Mises','Tresca','Goodman'});

ylabel('Factor of Safety');

title('Failure Theory Comparison');

grid on;


%% 22. S-N CURVE APPROXIMATION

% Number of cycles
cycles = logspace(3,7,100);

% Simplified S-N relationship
S_high = 0.9*Sut;
S_low = Se;

stress_SN = S_high - ...
    (S_high-S_low) * ...
    (log10(cycles)-3)/(7-3);

figure;

semilogx(cycles,stress_SN,'LineWidth',2);

xlabel('Number of Cycles');
ylabel('Alternating Stress (MPa)');
title('Approximate S-N Curve');

grid on;


%% 23. FINAL MESSAGE

fprintf('\n');
fprintf('Project analysis completed successfully.\n');
fprintf('All required engineering plots have been generated.\n');
fprintf('====================================================\n');