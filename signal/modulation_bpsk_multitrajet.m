function [signal_bpsk, signal_recu_filtre_bpsk, echelle, echelle_filtre] = modulation_bpsk_multitrajet(bits, Fe, Rb)
    % modulation_bpsk : Modulation BPSK d'une séquence binaire avec multitrajet
    % Entrées :
    %   bits : vecteur de 0 et 1 (signal binaire)
    %   Fe   : fréquence d'échantillonnage (Hz)
    %   Rb   : débit binaire (bits/s)
    % Sorties :
    %   signal_bpsk : signal BPSK modulé (passe-bas équivalent)
    %   echelle : échelle de temps pour le signal BPSK

    % Paramètres
    N = length(bits);               % Nombre de bits    symbols = 2*bits - 1;
    M = 2;
    Rs = Rb;
    Ns = Fe/Rs;
    Te = 1/Fe;                      % Période d'échantillonnage

    alpha0 = 1;
    alpha1 = 0.5;
    tau0 = 0;
    tau1 = 1/Rs;

    % Mapping
    symboles = 2*bits - 1;
     
    % Suréchantillonnage
    somme_Diracs_ponderes=kron(symboles ,[1 zeros(1,Ns-1)]);
    
    % Filtrage de mise en forme
    h = ones(1, Ns);
    signal_emis_bpsk = filter(h,1,somme_Diracs_ponderes);

    % Canal de propagation
    dirac_tau0 = [1 zeros(1, Ns-1)];
    dirac_tau1 = [zeros(1, Ns-1) 1];

    hc = alpha0*dirac_tau0 + alpha1*dirac_tau1;
    signal_recu_bpsk = filter(hc,1,signal_emis_bpsk);

    % Filtrage de réception
    hr = h;
    signal_recu_filtre_bpsk = filter(hr,1,signal_recu_bpsk);


    % Échantillonnage à n0 + mNs
    n0 = Ns;
    signal_bpsk = signal_recu_filtre_bpsk(Ns:Ns:end);

    % Échelle de temps
    echelle = 0:Te:(length(signal_bpsk)-1)*Te;
    echelle_filtre = 0:Te:(length(signal_recu_filtre_bpsk)-1)*Te;

end