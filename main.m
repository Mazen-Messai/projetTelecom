clear all;
close all;
addpath('signal');

%paramètres
bits = [0 1 1 0 0 1]; %bits
Fe = 24000;           %Fréquence d'échantillonage
Rb = 3000;            %Débit binaire
[signal_bpsk, signal_recu_filtre_bpsk, echelle, echelle_filtre, oeil_bpsk, TEB_bpsk] = modulation_bpsk_multitrajet(bits, Fe, Rb);

%tracé du signal reçu en sortie du filtre de réception bpsk
figure
plot(echelle_filtre, signal_recu_filtre_bpsk, 'o');
title('Signal BPSK modulé');

%tracé du diagramme de l'oeil en sortie du filtre de réception bpsk
figure
plot(oeil_bpsk);
title(['Tracé du du diagramme de l oeil en sortie du filtre de réception bpsk']);

%tracé de la constellation en sortie du filtre de réception bpsk
figure
plot(real(signal_bpsk), imag(signal_bpsk), 'o');
xlabel('a_k');
ylabel('b_k');
title(['Tracé de la constellation en sortie du filtre de réception bpsk']);

