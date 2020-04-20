%% Energiemodelle und -analysen: Uebung 1

%% Aufgabe 1.2) a) Modellansaetze

% Modell 1: p_t = beta_0 + beta_1*Netzlast + beta_2*Wind + beta_3*PV

% Modell 2: p_t = beta_0*(Netzlast^beta_1)*(Erneuerbare^beta_2) 

% Modell 3: p_t = beta_0 + beta_1*Netzlast + beta_2*Wind + beta_3*PV
%                +beta_4*p_(t-1)

%% Aufgabe 1.2) b) Regression 

clc
clear all
close all

% Einlesen der Excel Datei
daten_preis_last = readmatrix('Daten_Preise_Last_2012.xlsx');

% Zuweisen der jeweiligen Daten
Netzlast = daten_preis_last(:,5);
Wind = daten_preis_last(:,6);
PV = daten_preis_last(:,7);
Spotpreis = daten_preis_last(:,8);
Residuallast = daten_preis_last(:,9);
Erneuerbare = daten_preis_last(:,10);

% Modell 1 (Linear)
input_1 = [Netzlast, Wind, PV];
Modell_1 = fitlm(input_1, Spotpreis, 'linear');
disp(Modell_1)

% Modell 2 (Logarithmisch)
input_2 = [log(Netzlast),log(Erneuerbare)];
Spotpreis_aufbereitet = Spotpreis;
Spotpreis_aufbereitet(Spotpreis_aufbereitet<=0)=0.01;
Modell_2 = fitlm(input_2, log(Spotpreis_aufbereitet),'linear');
disp(Modell_2)

% Modell 3 (LAG)
input_3 = [Netzlast(2:end), Wind(2:end), PV(2:end), Spotpreis(1:end-1)];
Modell_3 = fitlm(input_3, Spotpreis(2:end), 'linear');
disp(Modell_3)


%Graphiken - Linear, Log, LAG

%Linear
figure(1)
plot(Modell_1,'Color',"#77AC30",'Marker','o','MarkerFaceColor','w')
title("Lineares Strompreismodell")
xlabel("Last [MW]")
ylabel("Preis [€/MWh]")
legend off
box off

%Log
%figure(2)
%plot(Modell_2,'Color',"#77AC30",'Marker','o','MarkerFaceColor','w')
%title("Logarithmisches Strompreismodell")
%xlabel("Last [MW]")
%ylabel("Preis [€/MWh]")
%legend off

%log - zürück transformiert
figure(2)
y = exp(-18.947) .* Netzlast.^2.2529 .*Erneuerbare.^-0.24859;
scatter(Netzlast,y, 30,'MarkerEdgeColor','#77AC30', 'MarkerFaceColor','w')
yticks([-20:20:180]);
title("Logarithmisches Strompreismodell")
xlabel("Last [MW]")
ylabel("Preis [€/MWh]")
hold on
%linear curve fitting y = m*x + b
nSamples = length(Netzlast);
X = [ ones(nSamples,1) Netzlast(:)];
a = (X.'*X)\(X.'*Spotpreis(:));
b = a(1);
m = a(2);
xa = min(Netzlast);
xb = max(Netzlast);
x = linspace(xa,xb,100);
f = b + m*x;
plot(x,f,'-r');
hold off


%LAG
figure(3)
plot(Modell_3,'Color',"#77AC30",'Marker','o','MarkerFaceColor','w')
title("LAG Strompreismodell")
xlabel("Last [MW]")
ylabel("Preis [€/MWh]")
legend off
box OFF















        