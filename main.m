clear all;
close all;
addpath('signal');

bits = [0 1 1 0 0 1];
Fe = 24000;
Rb = 3000;
[signal_bpsk, signal_recu_filtre_bpsk, echelle, echelle_filtre] = modulation_bpsk_multitrajet(bits, Fe, Rb);

figure
plot(echelle_filtre, signal_recu_filtre_bpsk, 'o');
title('Signal BPSK modulé');