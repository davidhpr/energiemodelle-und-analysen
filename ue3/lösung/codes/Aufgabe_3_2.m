%% Inititalisierung
clear all
close all
clc
yalmip('clear');

%% Parameter 
% Zeit
t = 1:24;
T = numel(t);
% Definition der thermischen KW - Zertifikatspreis
C_CO2 = 7; % EUR/tCO2

% Definition der Einspeisevergütug in €/MWh
E_Wind = 70;
E_PV = 100;

thermalPlant.Erzeugung = {'Kohle','GuD','Gasturbine', 'Wind', 'PV'};
[~, thermalPlant.types] = size(thermalPlant.Erzeugung); % Anzahl der unterschiedlichen Erzeugungskraftwerke wird in thermalPlant.types gespeichert (hier die Zahl 3)
thermalPlant.power = [600,400,300,500,100]'; % MW
thermalPlant.efficiency = [0.41, 0.58, 0.4, 1, 1]';
thermalPlant.fuel_price = [10, 25, 25, -E_Wind, -E_PV]'; % EUR/MWh_prim 
thermalPlant.emission_factor = [0.35, 0.2, 0.2, 0, 0]'; % tCO2/MWh_prim
thermalPlant.emissions = thermalPlant.emission_factor./thermalPlant.efficiency;
thermalPlant.MC = ...
    (thermalPlant.fuel_price + thermalPlant.emission_factor*C_CO2)./thermalPlant.efficiency; % marginal costs

% Nachfrage: hier die der Gruppennummer entsprechende Spalte aus dem excel-file lesen
% Last = xlsread('Last_PV_Wind', 'B4:B27')'; % MW

Last = xlsread('Last_PV_Wind', 'B4:B27')'; % MW
Wind = xlsread('Last_PV_Wind', 'E4:E27')';
PV = xlsread('Last_PV_Wind', 'F4:F27')';

%% Yalmip Optimization Problem Formulation
% Entscheidungsvariablen
PowerThermal = sdpvar(thermalPlant.types, T); % sdpvar-Matrix 3x24 (3 Kraftwerkstypen * 24 Stunden) erstellen

% Beschränkungen
Constraints = [];
% Beschränkung je KW-Typ
for i=1:T
    Constraints = [Constraints, 0 <= PowerThermal(:,i) <= thermalPlant.power]; % Einhaltung der Leistungsbereiche 0 bis 600MW für Kohle, 0 bis 400MW für GuD, 0 bis 300MW für Gasturbine
    
    % hier gehört eigentlich noch eine IF-Abfrage dazu, die überprüft ob
    % die Last insgesamt höher ist als die erzeugte erneuerbare Energie...
    % ist in unserem Beispiel aber nicht relevant, da sie über den gesamten Tag
    % sowieso viel höher ist als die erzeugte erneuerbare Energie (oder
    % hier in dem Fall Leistung).
    Constraints = [Constraints, PowerThermal(4,i) == Wind(i)];
    Constraints = [Constraints, PowerThermal(5,i) == PV(i)];
end
% Bedingung zur Nachfragedeckung
Constraints = [Constraints, sum(PowerThermal) == Last(t)];

% Zielfunktion: Erzeugungskosten
% HIER EINSETZEN! 
%TotalCosts = ...

TotalCosts = sum(PowerThermal,2)'*thermalPlant.MC; % Quersumme der Leistungen jeder Stunde pro Kraftwerk MAL den €/MW-Satz des jeweiligen Kraftwerks.
TotalCosts_wo_renewable = sum(PowerThermal(1:3,:),2)'*thermalPlant.MC(1:3,:);

%% Run Optimiztion Problem 
options = sdpsettings('solver', 'Gurobi', 'verbose', 1);
z = TotalCosts;

% Optimierungsproblem lösen
tic; 
optimize(Constraints, z, options); 
time2solve = toc;

fprintf('\n\nKraftwerksnutzung in MW je Stunde: \n Stunde Kohle  GuD  Gasturbine\n');

Kraftwerksnutzung=value(PowerThermal(:,:))'; % Kraftwerksnutzung in MW zu jeder Stunde und Kraftwerk
disp([(1:24)', Kraftwerksnutzung])

format short % Command Window Zahlenformat, falls es mal anders definiert wurde hier auf short "resetten"
Emissionen=sum(sum(Kraftwerksnutzung).*thermalPlant.emissions',2); % Treibhausgas-Emissionen in Tonnen CO2

fprintf('Emissionen: %.0f Tonnen CO2\n', Emissionen);

fprintf('Total System Cost: %.0f€, Time: %f\n', value(z), time2solve);

fprintf('Total System Cost without renewable energy thermal power plants: %.0f€, Time: %f\n', value(TotalCosts_wo_renewable), time2solve);

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
    'FaceColor',[0.8 1 0.2]);
set(area1(5),'DisplayName',thermalPlant.Erzeugung{5},...
    'FaceColor',[0.8 0.5 1]);
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
format short

Grenzkosten=(dual(Constraints(73))*-1)' % Stündliche Grenzkosten


