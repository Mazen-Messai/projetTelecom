function [signal_bpsk, signal_recu_filtre_bpsk, echelle, echelle_filtre, oeil_bpsk, TEB_bpsk] = modulation_bpsk_multitrajet(bits, Fe, Rb)
    % modulation_bpsk : Modulation BPSK d'une séquence binaire avec multitrajet
    % Entrées :
    %   bits : vecteur de 0 et 1 (signal binaire)
    %   Fe   : fréquence d'échantillonnage (Hz)
    %   Rb   : débit binaire (bits/s)
    % Sorties :
    %   signal_bpsk : signal BPSK modulé (passe-bas équivalent)
    %   echelle : échelle de temps pour le signal BPSK

    % Paramètres
    N = length(bits);               % Nombre de bits
    M = 2;                          % Nombre de symboles
    Rs = Rb;                        % débit symboles
    Ns = Fe/Rs;                     %facteur de suréchantillonnage
    Te = 1/Fe;                      % Période d'échantillonnage
    
    %paramètres du filtrage canal multitrajet
    alpha0 = 1;              % coeff d'attenuation du trajet direct
    alpha1 = 0.5;           % coeff d'atténuation du trajet réfléchi
    tau0 = 0;               % retard sur la ligne directe
    tau1 = 1/Rs;            % retard sur la ligne réfléchie

    % Mapping binaire centré
    symboles = 2*bits - 1;

    % Suréchantillonnage
    somme_Diracs_ponderes=kron(symboles ,[1 zeros(1,Ns-1)]);

    % Filtrage de mise en forme rectangulaire de longueur Ts
    h = ones(1, Ns);
    signal_emis_bpsk = filter(h,1,somme_Diracs_ponderes);

    % Canal de propagation
    dirac_tau0 = [1 zeros(1, Ns-1)]; %dirac en tau0 = 0
    dirac_tau1 = [zeros(1, Ns-1) 1]; %dirac en tau1 = Ts

    %filtrage multitrajet
    hc = alpha0*dirac_tau0 + alpha1*dirac_tau1; %réponse impulsionnelle du canal passe-bas équivalent au canal multitrajets
    signal_recu_bpsk = filter(hc,1,signal_emis_bpsk);

    % Filtrage de réception
    hr = h;
    signal_recu_filtre_bpsk = filter(hr,1,signal_recu_bpsk);


    % Échantillonnage à n0 + mNs
    n0 = Ns;
    signal_bpsk = signal_recu_filtre_bpsk(n0:Ns:end);

    % Échelle de temps
    echelle = 0:Te:(length(signal_bpsk)-1)*Te;
    echelle_filtre = 0:Te:(length(signal_recu_filtre_bpsk)-1)*Te;

    %oeil en sortie du filtre de reception
    oeil_bpsk =reshape(signal_recu_filtre_bpsk,Ns,length(signal_recu_filtre_bpsk)/Ns);

    %symboles reçus
    symboles_recus = (signal_bpsk > 0) * 2 - 1;

    %bits reçus
    bits_recus = (symboles_recus + 1) / 2;
    %calcul du TEB
    TEB_bpsk = (sum(bits_recus ~= bits)) / length(bits);
end