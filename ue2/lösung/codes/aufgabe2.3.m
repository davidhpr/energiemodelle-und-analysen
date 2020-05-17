%% Teil b

clear all; 
close all;

yalmip('clear');



c = [8 10 7 6 11 9]; % Millionen EUR
A = [-12 -9 -25 -20 -17 -13;
    -35 -42 -18 -31 -56 -49;
    -37 -53 -28 -24 -29 -20];
b = [-60 -150 -125];

x = sdpvar(1,6); % x(1) ... S1, x(2) ... S2, x(3) ... F1, x(4) ... F2, x(5) ... B1, x(6) ... B2, 

% Nebenbedingungen
Constraints = [];
Constraints = [Constraints, x >= zeros(1,6)]; % Nicht-Negativität
Constraints = [Constraints, x <= ones(1,6)]; % Nicht-Negativität


Constraints = [Constraints, 12*x(1)+9*x(2)+25*x(3)+20*x(4)+17*x(5)+13*x(6) >= 60]; % 1. Zeile
Constraints = [Constraints, 35*x(1)+42*x(2)+18*x(3)+31*x(4)+56*x(5)+49*x(6) >= 150]; % 2. Zeile
Constraints = [Constraints, 37*x(1)+53*x(2)+28*x(3)+24*x(4)+29*x(5)+20*x(6) >= 125]; % 3. Zeile

% Zielfunktion
z = c*x' % c(1)*x(1) + c(2)*x(2)

Options = sdpsettings('solver', 'GUROBI', 'verbose', 2);

% optimieren
tic;
sol = optimize(Constraints, z, Options) % minimiere die Kosten
time2solve = toc;

for i=1:6
    fprintf('my x(%.0f): %.3f Prozent \n',i, value(x(i))*100);
end
fprintf('Total costs: %.3f Millionen €, Time: %f\n', value(z), time2solve);


%% Teil c

clear all; 
close all;

yalmip('clear');



c = [8 10 7 6 11 9]; % Millionen EUR
A = [-12 -9 -25 -20 -17 -13;
    -35 -42 -18 -31 -56 -49;
    -37 -53 -28 -24 -29 -20];
b = [-60 -150 -125];

x = intvar(1,6); % x(1) ... S1, x(2) ... S2, x(3) ... F1, x(4) ... F2, x(5) ... B1, x(6) ... B2, 

% Nebenbedingungen
Constraints = [];
Constraints = [Constraints, x >= zeros(1,6)]; % Nicht-Negativität
Constraints = [Constraints, x <= ones(1,6)]; % Nicht-Negativität


Constraints = [Constraints, 12*x(1)+9*x(2)+25*x(3)+20*x(4)+17*x(5)+13*x(6) >= 60]; % 1. Zeile
Constraints = [Constraints, 35*x(1)+42*x(2)+18*x(3)+31*x(4)+56*x(5)+49*x(6) >= 150]; % 2. Zeile
Constraints = [Constraints, 37*x(1)+53*x(2)+28*x(3)+24*x(4)+29*x(5)+20*x(6) >= 125]; % 3. Zeile

% Zielfunktion
z = c*x' % c(1)*x(1) + c(2)*x(2)

Options = sdpsettings('solver', 'GUROBI', 'verbose', 2);

% optimieren
tic;
sol = optimize(Constraints, z, Options) % minimiere die Kosten
time2solve = toc;

for i=1:6
    fprintf('my x(%.0f): %.3f Prozent \n',i, value(x(i))*100);
end
fprintf('Total costs: %.3f Millionen €, Time: %f\n', value(z), time2solve);


%% Teil d

clear all; 
close all;

yalmip('clear');



c = [8 10 7 6 11 9]; % Millionen EUR
A = [-12 -9 -25 -20 -17 -13;
    -35 -42 -18 -31 -56 -49;
    -37 -53 -28 -24 -29 -20];
b = [-60 -150 -125];


% intvar(1,6) für nur integer variablen
x = intvar(1,6); % x(1) ... S1, x(2) ... S2, x(3) ... F1, x(4) ... F2, x(5) ... B1, x(6) ... B2, 

% Nebenbedingungen
Constraints = [];
Constraints = [Constraints, x >= zeros(1,6)]; % Nicht-Negativität
Constraints = [Constraints, x <= ones(1,6)]; % Nicht-Negativität

Constraints = [Constraints, x(1) + x(2) <= 1]; % Nicht-Gleich
Constraints = [Constraints, x(3) + x(4) <= 1]; % Nicht-Gleich
Constraints = [Constraints, x(5) + x(6) <= 1]; % Nicht-Gleich


Constraints = [Constraints, 12*x(1)+9*x(2)+25*x(3)+20*x(4)+17*x(5)+13*x(6) >= 60]; % 1. Zeile
Constraints = [Constraints, 35*x(1)+42*x(2)+18*x(3)+31*x(4)+56*x(5)+49*x(6) >= 150]; % 2. Zeile
Constraints = [Constraints, 37*x(1)+53*x(2)+28*x(3)+24*x(4)+29*x(5)+20*x(6) >= 125]; % 3. Zeile

% Zielfunktion
z = c*x' % c(1)*x(1) + c(2)*x(2)

Options = sdpsettings('solver', 'GUROBI', 'verbose', 2);

% optimieren
tic;
sol = optimize(Constraints, z, Options) % minimiere die Kosten
time2solve = toc;

for i=1:6
    fprintf('my x(%.0f): %.3f Prozent \n',i, value(x(i))*100);
end
fprintf('Total costs: %.3f Millionen €, Time: %f\n', value(z), time2solve);