clear all;
close all;
addpath('signal');
addpath('utils');
addpath('signal');
addpath('egaliseur');
addpath('analyse');


%paramètres
bits = randi([0 1], 1, 30)  % séquence aléatoire de 100 bits
Fe = 24000;           %Fréquence d'échantillonage
Rb = 3000;            %Débit binaire
Ns = Fe/Rb;

% Modulation bpsk multitrajet sans bruit
[signal_bpsk, signal_recu_filtre_bpsk, echelle, echelle_filtre, oeil_bpsk, TEB_bpsk, hc] = modulation_bpsk_multitrajet(bits, Fe, Rb);
% Modulation bpsk multitrajet avec bruit
[TEB_bpsk_bruit, TEB_theorique, tab_Eb_N0_dB] = modulation_bpsk_multitrajet_bruit(Fe, Rb);
% Modulation bpsk avec bruit sans canal multitrajet
[TEB_bpsk_sans_canal] = bpsk_multitrajet_bruit_sans_canal(Fe, Rb);

%tracé du signal reçu en sortie du filtre de réception bpsk sans bruit
figure
plot(echelle_filtre, signal_recu_filtre_bpsk, 'o');
title('Signal BPSK modulé');

%tracé de la constellation en sortie du filtre de réception bpsk sans bruit
figure
tracer_constellation(signal_bpsk, 'PSK', 2);

%tracé du diagramme de l'oeil en sortie du filtre de réception bpsk sans
%bruit
figure
plot(oeil_bpsk);
title(['Tracé du du diagramme de l oeil en sortie du filtre de réception bpsk']);

%tracé de la constellation en sortie du filtre de réception bpsk sans bruit
figure
plot(real(signal_bpsk), imag(signal_bpsk), 'o');
xlabel('a_k');
ylabel('b_k');
title(['Tracé de la constellation en sortie du filtre de réception bpsk']);

%tracé des TEB théoriques et simulés avec bruit
figure
semilogy(tab_Eb_N0_dB, TEB_theorique,'r-x')
hold on
semilogy(tab_Eb_N0_dB, TEB_bpsk_bruit,'b-o')
legend('TEB théorique','TEB simulé')
xlabel('E_b/N_0 en dB')
ylabel('TEB')

%comparaison TEB avec et sans canal multitrajet
figure
semilogy(tab_Eb_N0_dB, TEB_bpsk_sans_canal,'r-x')
hold on
semilogy(tab_Eb_N0_dB, TEB_bpsk_bruit,'b-o')
legend('TEB sans multitrajet','TEB avec multitrajet')
xlabel('E_b/N_0 en dB')
ylabel('TEB')


% Égaliseur MMSE
% 1A : Déterminer les coefficients du filtre MMSE
C = apprentissage_mmse(bits, signal_recu_filtre_bpsk, Ns, 5);

% 1B : Réponse en fréquence du canal de propagation
figure;
tracer_reponse_en_frequence(hc, C);

% 1C : Réponse impulsionnelle de lq chaîne de transmission;
figure;
tracer_reponse_impulsionnelle(hc, C);

% 1D :
% Générer une nouvelle séquence binaire à transmettre
N_bits2 = 100;                          % nombre de bits pour cette phase
bits2   = randi([0 1], 1, N_bits2);     % séquence aléatoire
symboles2 = 2*bits2 - 1;                % mapping BPSK (0→-1, 1→+1)

% Faire passer dans le canal + filtre de réception en réutilisant exactement la même chaîne que dans modulation_bpsk_multitrajet :
[~, signal_recu_bpsk2, ~, ~, ~, ~, hc2] = modulation_bpsk_multitrajet(bits2, Fe, Rb);

% Échantillonnage avant égalisation (un symbole par bit)
r2_sampled = signal_recu_bpsk2(Ns:Ns:end);
Lmin = min(length(r2_sampled), length(symboles2));
r2_sampled = r2_sampled(1:Lmin);
symboles2   = symboles2(1:Lmin);

% Appliquer l’égaliseur MMSE
y2_equal = egaliseur_mmse(r2_sampled, C); 

% Tracer la constellation AVANT égalisation
figure;
tracer_constellation(r2_sampled, 'PSK', 2);
title('Constellation BPSK avant égalisation');

% Tracer la constellation APRÈS égalisation
figure;
tracer_constellation(y2_equal, 'PSK', 2);
title('Constellation BPSK après égalisation MMSE');

% TEB sans égalisation :
[TEB2_noeq] = evaluer_teb(symboles2, r2_sampled);

% TEB avec égalisation :
[TEB2_eq]   = evaluer_teb(symboles2, y2_equal);

fprintf('TEB avant égalisation :  %.4e\n', TEB2_noeq);
fprintf('TEB après égalisation : %.4e\n', TEB2_eq);


% 2 :

% Choix d’un Eb/N0
EbN0_dB = 5;             % ex. 5 dB
EbN0_lin = 10^(EbN0_dB/10);

% Récupérer le signal suréchantillonné après filtre Rx SANS bruit
r_full = signal_recu_filtre_bpsk;

% Calculer la puissance du signal reçu pour dimensionner le bruit
P_signal = mean(abs(r_full).^2);

% Générer le bruit AWGN de puissance adaptée
P_bruit = P_signal / (2 * EbN0_lin * 1);  % BPSK => log2(2)=1
bruit  = sqrt(P_bruit) * randn(size(r_full));

% Signal bruité en sortie du filtre Rx
r_full_bruit = r_full + bruit;

% Échantillonnage 1 point/symbole (avant égalisation)
r_sampled_bruit = r_full_bruit(Ns:Ns:end);
Lmin = min(length(r_sampled_bruit), length(symboles2));
r_sampled_bruit = r_sampled_bruit(1:Lmin);
symboles_bruit  = symboles2(1:Lmin);

% TEB SANS égalisation
TEB_noeq_bruit = evaluer_teb(symboles_bruit, r_sampled_bruit);
fprintf('TEB sans égalisation (Eb/N0 = %d dB) = %.4e\n', EbN0_dB, TEB_noeq_bruit);

% Égalisation MMSE
y_equal_bruit = egaliseur_mmse(r_sampled_bruit, C);

% Alignement pour TEB APRÈS égalisation
L_valid        = length(y_equal_bruit);
sym_tx_valid   = symboles_bruit(5+1 : 5 + L_valid);

% TEB APRÈS égalisation
TEB_eq_bruit   = evaluer_teb(sym_tx_valid, y_equal_bruit);
fprintf('TEB avec égalisation MMSE (Eb/N0 = %d dB) = %.4e\n', EbN0_dB, TEB_eq_bruit);

% Tracé comparatif des TEB
figure;
bar([TEB_noeq_bruit, TEB_eq_bruit]);
set(gca, 'XTickLabel', {'Sans égalisation', 'Avec égalisation'});
ylabel('TEB');
title(sprintf('TEB comparé (Eb/N_0 = %d dB)', EbN0_dB));
grid on;