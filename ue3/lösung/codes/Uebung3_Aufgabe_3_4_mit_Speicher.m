%% Inititalisierung
clear all
close all
clc
yalmip('clear');

%% Parameter 
% Zeit
t = 1:24;
T = numel(t);
% Definition der thermischen KW
C_CO2 = 109;
% Definition der Einspeisevergütug
E_Wind = 70;
E_PV = 100;

thermalPlant.Erzeugung = {'Kohle','GuD','Gasturbine', 'Wind', 'PV', 'Turbinieren', 'Pumpen'};
[~, thermalPlant.types] = size(thermalPlant.Erzeugung);
thermalPlant.power = [600,400,300,500,100,200,200]'; % MW
thermalPlant.efficiency = [0.41, 0.58, 0.4, 1, 1, 0.9, 0.9]';
thermalPlant.fuel_price = [10, 25, 25, -E_Wind, -E_PV, 0, 0]'; % EUR/MWh_prim 
thermalPlant.emission_factor = [0.35, 0.2, 0.2, 0, 0, 0, 0]'; % tCO2/MWh_prim
thermalPlant.emissions = thermalPlant.emission_factor./thermalPlant.efficiency;
thermalPlant.MC = ...
    (thermalPlant.fuel_price + thermalPlant.emission_factor*C_CO2)./thermalPlant.efficiency; % marginal costs

% Nachfrage: hier die der Gruppennummer entsprechende Spalte aus dem excel-file lesen
Last = xlsread('Last_PV_Wind', 'B4:B27')'; % MW
Wind = xlsread('Last_PV_Wind', 'E4:E27')';
PV = xlsread('Last_PV_Wind', 'F4:F27')';

%% Yalmip Optimization Problem Formulation
% Entscheidungsvariablen
PowerThermal = sdpvar(thermalPlant.types, T);
Pumpspeicher = sdpvar(1,T);

% Beschränkungen
Constraints = [];
% Beschränkung je KW-Typ
for i=1:T
    Constraints = [Constraints, 0 <= PowerThermal(1:6,i) <= thermalPlant.power(1:6)];
    Constraints = [Constraints, -thermalPlant.power(7) <= PowerThermal(7,i) <= 0];
    
    Constraints = [Constraints, PowerThermal(4,i) == Wind(i)];
    Constraints = [Constraints, PowerThermal(5,i) == PV(i)];
    
    Constraints = [Constraints, PowerThermal(6,1) == 0];
    
    Constraints = [Constraints, 0 <= Pumpspeicher(1,i) <= 600];
    Constraints = [Constraints, Pumpspeicher(1,1) == 0];
    
    if i>1
        Constraints = [Constraints, Pumpspeicher(1,i) == Pumpspeicher(1,i-1) - PowerThermal(6,i)/thermalPlant.efficiency(6) - PowerThermal(7,i)*thermalPlant.efficiency(7)];
    end
end
% Bedingung zur Nachfragedeckung
Constraints = [Constraints, sum(PowerThermal) == Last(t)];

% Zielfunktion: Emissionen 
TotalCosts = sum(PowerThermal,2)'*thermalPlant.MC;
TotalEmissions = sum(PowerThermal,2)'*thermalPlant.emissions;

%% Run Optimiztion Problem 
options = sdpsettings('solver', 'Gurobi', 'verbose', 1);
z = TotalCosts;
%z = TotalEmissions;

% Optimierungsproblem lösen
tic; 
optimize(Constraints, z, options); 
time2solve = toc;

%% Ergebnisse darstellen
PowerThermal = value(PowerThermal);

figure1 = figure('Name', 'Erzeugung nach Kraftwerkstyp');

axes1 = axes('Parent',figure1);
hold(axes1,'on');

area1 = area(PowerThermal','Parent',axes1);
set(area1(1),'DisplayName',thermalPlant.Erzeugung{1},...
    'FaceColor',[0.4 0.2 0]);
set(area1(2),'DisplayName',thermalPlant.Erzeugung{2},...
    'FaceColor',[0.7 0 0]);
set(area1(3),'DisplayName',thermalPlant.Erzeugung{3},...
    'FaceColor',[0.8 0.5 0.2]);
set(area1(4),'DisplayName',thermalPlant.Erzeugung{4},...
    'FaceColor',[0.8 1 0.2]) ; 
set(area1(5),'DisplayName',thermalPlant.Erzeugung{5} ,...
    'FaceColor',[0.8 0.5 1]) ;
set(area1(6),'DisplayName',thermalPlant.Erzeugung{6} ,...
    'FaceColor',[0.2 0.7 1]) ;
set(area1(7),'DisplayName',thermalPlant.Erzeugung{7} ,...
    'FaceColor',[0.1 0.1 0.2]) ;

hold all
plot(Last(t), ...
    'DisplayName', 'Last',...
    'Linestyle', ':',...
    'Color', [0,0,0],...
    'Linewidth', 1.5);

box(axes1,'on');
legend(axes1,'show');

title('Produktion nach Kraftwerkstyp');
xlabel('Zeit in h');
ylabel('Leistung in MW');

fprintf('Total Emissions: %.0f tCO2\n', sum(thermalPlant.emissions'*value(PowerThermal)));
fprintf('Total Costs: %.0f EUR\n', sum(thermalPlant.MC'*value(PowerThermal)));
                  