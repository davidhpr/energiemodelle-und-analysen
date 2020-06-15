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

% Definition des Energiespeichers
Speicher.max = 600; % Energiespeichergröße in MWh 
Speicher.min = 0; % Minimalstand des Speichers in MWh
Speicher.efficiency = 0.9; % Effizients der Pumpe und der Turbine (gleichwertig)
Speicher.power = 200; % Leistung der Pumpe und der Turbine in MW

thermalPlant.Erzeugung = {'Kohle','GuD','Gasturbine', 'Wind', 'PV', 'Turbine', 'Pumpe'};
[~, thermalPlant.types] = size(thermalPlant.Erzeugung); % Anzahl der unterschiedlichen Erzeugungskraftwerke wird in thermalPlant.types gespeichert (hier die Zahl 3)
thermalPlant.power = [600,400,300,500,100,Speicher.power,Speicher.power]'; % MW
thermalPlant.efficiency = [0.41, 0.58, 0.4, 1, 1, Speicher.efficiency, Speicher.efficiency]';
thermalPlant.fuel_price = [10, 25, 25, -E_Wind, -E_PV, 0, 0]'; % EUR/MWh_prim 
thermalPlant.emission_factor = [0.35, 0.2, 0.2, 0, 0, 0, 0]'; % tCO2/MWh_prim
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
Speicher.level = sdpvar(1, T); % 24 Entscheidungsvariablen für Speicherstand



% Beschränkungen
Constraints = [];
% Beschränkung je KW-Typ
for i=1:T
    Constraints = [Constraints, 0 <= PowerThermal(1:6,i) <= thermalPlant.power(1:6)]; % Einhaltung der Leistungsbereiche 0 bis 600MW für Kohle, 0 bis 400MW für GuD, 0 bis 300MW für Gasturbine
    Constraints = [Constraints, -thermalPlant.power(7) <= PowerThermal(7,i) <= 0]; % Maximierungsproblem. Pumpen wenn damit Kosten eingespart werden können.
    % hier gehört eigentlich noch eine IF-Abfrage dazu, die überprüft ob
    % die Last insgesamt höher ist als die erzeugte erneuerbare Energie...
    % ist in unserem Beispiel aber nicht relevant, da sie über den gesamten Tag
    % sowieso viel höher ist als die erzeugte erneuerbare Energie (oder
    % hier in dem Fall Leistung).
    Constraints = [Constraints, PowerThermal(4,i) == Wind(i)];
    Constraints = [Constraints, PowerThermal(5,i) == PV(i)];
    Constraints = [Constraints, 0 <= Speicher.level(i) <= Speicher.max];
    
    if i > 1 
        Constraints = [Constraints, Speicher.level(i) == Speicher.level(i-1) - PowerThermal(6,i)/thermalPlant.efficiency(6) - PowerThermal(7,i)*thermalPlant.efficiency(7)];
    end
end

Constraints = [Constraints, PowerThermal(6,1) == 0]; % Damit Turbine zur Stunde 0 nicht aktiv sein kann muss diese Bedingung hier aktiviert werden, da die Bedingung für den Speicherlevel erst ab Stunde 2 greift (siehe if Bedingung in for-schleife)
Constraints = [Constraints, Speicher.level(1) == 0];

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

fprintf('\n\nKraftwerksnutzung in MW je Stunde: \n Stunde, Kohle,  GuD,  Gasturbine, Wind, PV, Turbinieren, Pumpen\n');

Kraftwerksnutzung=value(PowerThermal(:,:))'; % Kraftwerksnutzung in MW zu jeder Stunde und Kraftwerk
disp([(1:24)', fix(Kraftwerksnutzung)])

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
set(area1(6),'DisplayName',thermalPlant.Erzeugung{6},...
    'FaceColor',[0.3 0.2 1]);
set(area1(7),'DisplayName',thermalPlant.Erzeugung{7},...
    'FaceColor',[0.1 0.9 1]);
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

Grenzkosten=(dual(Constraints(146))*-1)'; % Stündliche Grenzkosten


