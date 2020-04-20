% ################### WICHTIG!! #####################
% Für die Darstellung des cprintf-Befehls wird folgendes Plugin benötigt
% https://de.mathworks.com/matlabcentral/fileexchange/24093-cprintf-display-formatted-colored-text-in-the-command-wind
% ###################################################


% Alles löschen, alle Variablen entfernen, alle Fenster/Abbildungen schließen
clc; clear all; close all;

% Excel-Sheet Waermenachfrage_Uebung1.xls importieren
arbeitstabelle=readtable("..\Angabe_Uebung_1\Waermenachfrage_Uebung1.xlsx");

%% Mittelwert
cprintf('-err', '\n\nTemperatur - Mittelwert-Berechnung\n');
Mittelwert=mean(arbeitstabelle.Temp)

%%
% Berechnung Modell 1
cprintf('-err', '\n\nModell 1 - Berechnung\n');
mdl_1 = fitlm(arbeitstabelle.Temp,arbeitstabelle.Nachfrage)

% Spalten Stunde^2 und Stunde^3 für Model 2 hinzufügen.
arbeitstabelle.('Stunde^2') = arbeitstabelle.Stunde.^2;
arbeitstabelle.('Stunde^3') = arbeitstabelle.Stunde.^3;

% Berechnung Modell 2 – lineare Regression mit 3 weiteren Variablen
cprintf('-err', '\n\nModell 2 - Berechnung\n')
mdl_2 = fitlm([arbeitstabelle.('Temp'), arbeitstabelle.('Stunde'), arbeitstabelle.('Stunde^2'), arbeitstabelle.('Stunde^3')],  arbeitstabelle.('Nachfrage'))

% LAG Spalte hinzufügen für Modell 3
arbeitstabelle.('LAG')= [0; arbeitstabelle.('Nachfrage')(1:end-1)];

% Berechnung Modell 3
cprintf('-err', '\n\nModell 3 - Berechnung\n')
mdl_3 = fitlm([arbeitstabelle.('Temp'), arbeitstabelle.('LAG')],  arbeitstabelle.('Nachfrage'))


% figure()
% % Scatterplott erstellen
% scatter(table.Temp,table.Nachfrage);
% 
% y = mdl_2.Coefficients.Estimate(1)+mdl_2.Coefficients.Estimate(2)*table.('Temp')+mdl_2.Coefficients.Estimate(3)*table.('Stunde')+mdl_2.Coefficients.Estimate(4)*table.('Stunde^2')+mdl_2.Coefficients.Estimate(5)*table.('Stunde^3');
% hold on;
% plot(table.('Temp'),y)
% 
% figure()
% % Scatterplott erstellen
% scatter(table.Temp,table.Nachfrage);
% 
% y = mdl_3.Coefficients.Estimate(1)+mdl_3.Coefficients.Estimate(2)*table.('Temp')+mdl_3.Coefficients.Estimate(3)*table.('LAG');
% hold on;
% plot(table.('Temp'),y)

figure('NumberTitle', 'off', 'Name', 'Wochenübersicht Winter (7.1.2008 - 13.1.2008)')
set(gcf,'Position',[0 50 900 1200])
time=(2352:2519);
y = mdl_1.Coefficients.Estimate(1)+mdl_1.Coefficients.Estimate(2)*arbeitstabelle.('Temp');
subplot(3,1,1)
plot(arbeitstabelle.('Nachfrage')(time))
hold on;
plot(y(time),'r--')
legend('Historische Nachfrage', 'Modellnachfrage linear')
title('Vergleich Modell 1')
grid on;
xlim([1,168]);
xticks(1:12:168);
xticklabels({'','Tag 1', '','Tag 2', '','Tag 3', '','Tag 4', '','Tag 5', '','Tag 6', '','Tag 7'});

y = mdl_2.Coefficients.Estimate(1)+mdl_2.Coefficients.Estimate(2)*arbeitstabelle.('Temp')+mdl_2.Coefficients.Estimate(3)*arbeitstabelle.('Stunde')+mdl_2.Coefficients.Estimate(4)*arbeitstabelle.('Stunde^2')+mdl_2.Coefficients.Estimate(5)*arbeitstabelle.('Stunde^3');
subplot(3,1,2)
plot(arbeitstabelle.('Nachfrage')(time))
hold on;
plot(y(time),'r--')
legend('Historische Nachfrage', 'Modellnachfrage linear')
title('Vergleich Modell 2')
grid on;
xlim([1,168]);
xticks(1:12:168);
xticklabels({'','Tag 1', '','Tag 2', '','Tag 3', '','Tag 4', '','Tag 5', '','Tag 6', '','Tag 7'});

y = mdl_3.Coefficients.Estimate(1)+mdl_3.Coefficients.Estimate(2)*arbeitstabelle.('Temp')+mdl_3.Coefficients.Estimate(3)*arbeitstabelle.('LAG');
subplot(3,1,3)
plot(arbeitstabelle.('Nachfrage')(time))
hold on;
plot(y(time),'r--')
legend('Historische Nachfrage', 'Modellnachfrage linear')
title('Vergleich Modell 3')
grid on;
xlim([1,168]);
xticks(1:12:168);
xticklabels({'','Tag 1', '','Tag 2', '','Tag 3', '','Tag 4', '','Tag 5', '','Tag 6', '','Tag 7'});

suplabel('y-Achse: Nachfrage in MW', 'y'); 
suplabel('x-Achse: Stunden des Betrachtungszeitraums', 'x'); 

figure('NumberTitle', 'off', 'Name', 'Wochenübersicht Sommer (28.6.2008 - 4.7.2008)')
set(gcf,'Position',[900 50 900 1200])
time=(6504:6671);
y = mdl_1.Coefficients.Estimate(1)+mdl_1.Coefficients.Estimate(2)*arbeitstabelle.('Temp');
subplot(3,1,1)
plot(arbeitstabelle.('Nachfrage')(time))
hold on;
plot(y(time),'r--')
legend('Historische Nachfrage', 'Modellnachfrage linear')
title('Vergleich Modell 1')
grid on;
xlim([1,168]);
xticks(1:12:168);
xticklabels({'','Tag 1', '','Tag 2', '','Tag 3', '','Tag 4', '','Tag 5', '','Tag 6', '','Tag 7'});

y = mdl_2.Coefficients.Estimate(1)+mdl_2.Coefficients.Estimate(2)*arbeitstabelle.('Temp')+mdl_2.Coefficients.Estimate(3)*arbeitstabelle.('Stunde')+mdl_2.Coefficients.Estimate(4)*arbeitstabelle.('Stunde^2')+mdl_2.Coefficients.Estimate(5)*arbeitstabelle.('Stunde^3');
subplot(3,1,2)
plot(arbeitstabelle.('Nachfrage')(time))
hold on;
plot(y(time),'r--')
legend('Historische Nachfrage', 'Modellnachfrage linear')
title('Vergleich Modell 2')
grid on;
xlim([1,168]);
xticks(1:12:168);
xticklabels({'','Tag 1', '','Tag 2', '','Tag 3', '','Tag 4', '','Tag 5', '','Tag 6', '','Tag 7'});

y = mdl_3.Coefficients.Estimate(1)+mdl_3.Coefficients.Estimate(2)*arbeitstabelle.('Temp')+mdl_3.Coefficients.Estimate(3)*arbeitstabelle.('LAG');
subplot(3,1,3)
plot(arbeitstabelle.('Nachfrage')(time))
hold on;
plot(y(time),'r--')
legend('Historische Nachfrage', 'Modellnachfrage linear')
title('Vergleich Modell 3')
grid on;
xlim([1,168]);
xticks(1:12:168);
xticklabels({'','Tag 1', '','Tag 2', '','Tag 3', '','Tag 4', '','Tag 5', '','Tag 6', '','Tag 7'});

suplabel('y-Achse: Nachfrage in MW', 'y'); 
suplabel('x-Achse: Stunden des Betrachtungszeitraums', 'x'); 

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Aufgabe d, Vergleichen der Scatterplots der drei Modelle %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure('NumberTitle', 'off', 'Name', 'Aufgabe d');
set(gcf,'Position',[1800 50 900 1200])
%% Modell 1
subplot(3,1,1)
% Scatterplott erstellen
scatter(arbeitstabelle.Temp,arbeitstabelle.Nachfrage);
title('Modell 1')

% Gerade in Scatterplot einzeichnen.
y = mdl_1.Coefficients.Estimate(1)+mdl_1.Coefficients.Estimate(2)*arbeitstabelle.('Temp');
hold on;
plot(arbeitstabelle.('Temp'),y)

%% Model 2
subplot(3,1,2)
scatter(arbeitstabelle.Temp,arbeitstabelle.Nachfrage);
title('Modell 2')
y = mdl_2.Coefficients.Estimate(1)+mdl_2.Coefficients.Estimate(2)*arbeitstabelle.('Temp')+mdl_2.Coefficients.Estimate(3)*arbeitstabelle.('Stunde')+mdl_2.Coefficients.Estimate(4)*arbeitstabelle.('Stunde^2')+mdl_2.Coefficients.Estimate(5)*arbeitstabelle.('Stunde^3');
hold on;
plot(arbeitstabelle.('Temp'),y)


%% Model 3
subplot(3,1,3)
scatter(arbeitstabelle.Temp,arbeitstabelle.Nachfrage);
title('Modell 3')
y = mdl_3.Coefficients.Estimate(1)+mdl_3.Coefficients.Estimate(2)*arbeitstabelle.('Temp')+mdl_3.Coefficients.Estimate(3)*arbeitstabelle.('LAG');
hold on;
plot(arbeitstabelle.('Temp'),y)

suplabel('y-Achse: Nachfrage in MW', 'y'); 
suplabel('x-Achse: Temperatur in Grad °C', 'x'); 



%% Berechnung Modell 4

cprintf('-err', '\n\nAufgabe 1.1 - Modell 4\n')

cprintf('-err', '\n\nAufgabe 1.1 - Modell 4 - Unterpunkt a)\n')

%cprintf('-err', '\n\n---------------------------------------\n')

betas = {,};

for c=0:23
    %cprintf('-err', '\n\nModell 4 - STD%d \n',c);
  
    
    x=arbeitstabelle(arbeitstabelle.Stunde==c,:);
    y=[x.Temp];
    z=[x.Nachfrage];
    
    mdl_tmp=fitlm(y,z);
    betas(end+1,:) = {mdl_tmp.Coefficients.Estimate(1), mdl_tmp.Coefficients.Estimate(2)};
end

betas_aufgabe1_4a = cell2table(betas, 'VariableNames', {'Beta 0','Beta 1'})

figure('NumberTitle', 'off', 'Name', 'Aufgabe 1.1 - Modell 4 - Unterpunkt a');
plot(betas_aufgabe1_4a.('Beta 0'))
hold on;
plot(betas_aufgabe1_4a.('Beta 1'),'r--')
legend('Beta 0', 'Beta 1')
title('Koeffizienten Vergleich über die Stunden (0-23h)')
grid on;
xlabel('Stunde [h]')
ylabel('Koeffizientwert')
xlim([1,24]);
xticks(1:1:24);
xticklabels(0:23);

%% Aufgabe 1.1 Modell 4b
cprintf('-err', '\n\nAufgabe 1.1 - Modell 4 - Unterpunkt b)\n')
% cprintf('-err', '\n\nModell 4 - STD 7\n')
% 
% datstunde6=arbeitstabelle(arbeitstabelle.Stunde==7,:); 
% datstunde22=arbeitstabelle(arbeitstabelle.Stunde==1,:); 
% 
% inp_temp_Std6=[arbeitstabelle(arbeitstabelle.Stunde==7,:).Temp];
% inp_nachfrage_Std6=[datstunde6.Nachfrage];
% 
% 
% Modell_4_Std6=fitlm(arbeitstabelle(arbeitstabelle.Stunde==7,:).Temp,arbeitstabelle(arbeitstabelle.Stunde==7,:).Nachfrage)
% 
% cprintf('-err', '\n\nModell 4 - STD 1\n')
% 
% inp_temp_Std22=[datstunde22.Temp];
% inp_nachfrage_Std22=[datstunde22.Nachfrage];
% 
% Modell_4_Std22=fitlm(inp_temp_Std22,inp_nachfrage_Std22)

betas_aufgabe1_4a([2 8], [1 2])

%% Aufgabe 1.4c

cprintf('-err', '\n\nAufgabe 1.1 - Modell 4 - Unterpunkt c)\n')

mdl_aufgabe1_4c_Std1=fitlm(arbeitstabelle(arbeitstabelle.Stunde==1,:).Temp,arbeitstabelle(arbeitstabelle.Stunde==1,:).Nachfrage)
mdl_aufgabe1_4c_Std7=fitlm(arbeitstabelle(arbeitstabelle.Stunde==7,:).Temp,arbeitstabelle(arbeitstabelle.Stunde==7,:).Nachfrage)

aufgabe1_4c_heat1=predict(mdl_aufgabe1_4c_Std1,arbeitstabelle(arbeitstabelle.Stunde==1,:).Temp);
aufgabe1_4c_heat2=predict(mdl_aufgabe1_4c_Std7,arbeitstabelle(arbeitstabelle.Stunde==7,:).Temp);


figure('NumberTitle', 'off', 'Name', 'Aufgabe 1.1 - Modell 4 - d');
set(gcf,'Position',[1800 50 900 1200])
subplot(2,1,1)
plot(arbeitstabelle(arbeitstabelle.Stunde==1,:).Nachfrage)
hold on
plot(aufgabe1_4c_heat1,'r')

xlabel('Tage des Betrachtungszeitraums')
ylabel('Nachfrage [MW]')
title('Vergleich: tatsächliche Nachfrage zu Modell 4 - Stunde 1')
xlim([1,366]);
xticks(-14:30.4166:364);
xticklabels({'', 'Oktober', 'November', 'Dezember', 'Jänner','Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September'});
xtickangle(-45)
for c=1:30.4166:366
    xline(c,':');
end
legend('Historische Nachfrage', 'modellierte Nachfrage')

subplot(2,1,2)
plot(arbeitstabelle(arbeitstabelle.Stunde==7,:).Nachfrage)
hold on
plot(aufgabe1_4c_heat2,'r')
xlabel('Tage des Betrachtungszeitraums')
ylabel('Nachfrage [MW]')
title('Vergleich: tatsächliche Nachfrage zu Modell 4 - Stunde 7')
xlim([1,366]);
xticks(-14:30.4166:364);
xticklabels({'', 'Oktober', 'November', 'Dezember', 'Jänner','Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September'});
xtickangle(-45)
for c=1:30.4166:366
    xline(c,':');
end
legend('Historische Nachfrage', 'modellierte Nachfrage')


% 
% 
% figure
% plot(datstunde22.Nachfrage)
% hold on
% plot(modell4_heat2,'r')
% legend('Historische Nachfrage', 'Modellnachfrage Stunde 6')
% xlabel('Tage des Betrachtungszeitraums')
% ylabel('Nachfrage [MW]')
% title('Vergleich: Modell und Beobachtungen')




%-------------Modell 4 ende

%%
% Bissl aufräumen
clear betas mdl_tmp s x y z;

% %% Modell 5
% % Berechnung Modell 5
cprintf('-err', '\n\nModell 5 - Berechnung\n')
mdl_5_x = fitlm([arbeitstabelle.('Temp'), arbeitstabelle.('LAG'), arbeitstabelle.('Stunde'), arbeitstabelle.('Stunde^2'), arbeitstabelle.('Stunde^3')], arbeitstabelle.('Nachfrage'))

%% Scatterplot
y = predict(mdl_5_x, [arbeitstabelle.Temp, arbeitstabelle.LAG, arbeitstabelle.Stunde, arbeitstabelle.('Stunde^2'),arbeitstabelle.('Stunde^3')]);
figure('NumberTitle', 'off', 'Name', 'Aufgabe 1.1 - Modell 5');
scatter(arbeitstabelle.Temp,arbeitstabelle.Nachfrage);
title('Scatterplot - Modell 5')
hold on;
plot(arbeitstabelle.('Temp'),y)
suplabel('y-Achse: Nachfrage in MW', 'y'); 
suplabel('x-Achse: Temperatur in Grad °C', 'x');

