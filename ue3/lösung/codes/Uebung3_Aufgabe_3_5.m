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
C_CO2 = 0;
% Definition der Einspeisevergütug
E_Wind = 70;
E_PV = 100;
% Definition der maximalen CO2-Emissionen
CO2_Emission_max = 5793;

thermalPlant.Erzeugung = {'Kohle','GuD','Gasturbine', 'Wind', 'PV'};
[~, thermalPlant.types] = size(thermalPlant.Erzeugung);
thermalPlant.power = [600,400,300,500,100]'; % MW
thermalPlant.efficiency = [0.41, 0.58, 0.4, 1, 1]';
thermalPlant.fuel_price = [10, 25, 25, -E_Wind, -E_PV]'; % EUR/MWh_prim 
thermalPlant.emission_factor = [0.35, 0.2, 0.2, 0, 0]'; % tCO2/MWh_prim
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

% Beschränkungen
Constraints = [];
% Beschränkung je KW-Typ
for i=1:T
    Constraints = [Constraints, 0 <= PowerThermal(:,i) <= thermalPlant.power];
    
    Constraints = [Constraints, PowerThermal(4,i) == Wind(i)];
    Constraints = [Constraints, PowerThermal(5,i) == PV(i)];
end
% Bedingung zur Nachfragedeckung
Constraints = [Constraints, sum(PowerThermal) == Last(t)];

% Zusäztliche Nebenbedingung aus 3.5)a)
TotalEmissions = sum(PowerThermal,2)'*thermalPlant.emissions;
Constraints = [Constraints, (0 <= TotalEmissions <= CO2_Emission_max):'NB']; %Tag für die Nebenbedingung

% Zielfunktion: Erzeugungskosten 
TotalCosts = sum(PowerThermal,2)'*thermalPlant.MC;

%% Run Optimiztion Problem 
options = sdpsettings('solver', 'Gurobi', 'verbose', 1);
z = TotalCosts;

% Optimierungsproblem lösen
tic; 
optimize(Constraints, z, options); 
time2solve = toc;

fprintf('Total System Cost: %.0f, Time: %f\n', value(z), time2solve);

Schattenvariablen = dual(Constraints('NB'));

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
                  