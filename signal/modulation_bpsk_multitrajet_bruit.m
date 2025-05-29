function [TEB_bpsk, TEB_theorique, tab_Eb_N0_dB] = modulation_bpsk_multitrajet_bruit(Fe, Rb)
    % modulation_bpsk : Modulation BPSK d'une séquence binaire avec multitrajet
    % Entrées :
    %   bits : vecteur de 0 et 1 (signal binaire)
    %   Fe   : fréquence d'échantillonnage (Hz)
    %   Rb   : débit binaire (bits/s)
    % Sorties :
    %   signal_bpsk : signal BPSK modulé (passe-bas équivalent)
    %   echelle : échelle de temps pour le signal BPSK

    % Paramètres
    N = 10;               % Nombre de bits
    M = 2;                  %nombre de symboles
    Rs = Rb;                % débit symboles
    Ns = Fe/Rs;             % facteur de suréchantillonnage  
    Te = 1/Fe;                      % Période d'échantillonnage
    
    %paramètres filtrage multitrajet
    alpha0 = 1;             % coeff d'attenuation du trajet direct
    alpha1 = 0.5;           % coeff d'atténuation du trajet réfléchi
    tau0 = 0;               % retard sur la ligne directe
    tau1 = 1/Rs;            % retard sur la ligne réfléchie
    
    % tableaux des SNR par bit souhaité à l'entrée du récepteur (en dB et
    % en linéaire)
    tab_Eb_N0_dB = 0:7;             % SNR en dB
    tab_Eb_N0=10.^(tab_Eb_N0_dB/10); % SNR

    % initialisation des TEB théoriques et simulés
    TEB_theorique = [0 0 0 0 0 0 0 0];
    TEB_bpsk = [0 0 0 0 0 0 0 0];

    for indice_bruit=1:length(tab_Eb_N0_dB)
        Eb_N0_dB = tab_Eb_N0_dB(indice_bruit); % SNR en dB
        Eb_N0 = tab_Eb_N0(indice_bruit);       %SNR
        TEB_theorique(indice_bruit) = qfunc(sqrt(2 * Eb_N0));  %TEB théorique

        nb_erreurs=0;   % nombre d'erreurs cumulées
        nb_cumul=0;     % nombre de cumuls réalisés
        TEB=0;          % Initialisation du TEB pour le cumul

        % BOUCLE POUR PRECISION TEB MESURE : COMPTAGE NOMBRE ERREURS
        while(nb_erreurs<100)
            %bits
            bits = randi([0,1], 1, N);
            % Mapping binaire centré
            symboles = 2*bits - 1;

            % Suréchantillonnage
            somme_Diracs_ponderes=kron(symboles ,[1 zeros(1,Ns-1)]);

            % Filtrage de mise en forme rectangulaire de longueur Ts
            h = ones(1, Ns);
            signal_emis_bpsk = filter(h,1,somme_Diracs_ponderes);

            % Canal de propagation
            %Calcul de la puissance du signal émis
            P_signal= Fe * mean((signal_emis_bpsk-mean(signal_emis_bpsk)).^2);
            %Calcul de la puissance du bruit à ajouter au signal pour obtenir la valeur
            %souhaité pour le SNR par bit à l'entrée du récepteur (Eb/N0)
            P_bruit= (Ns * P_signal) / (2 * log2(M) * Eb_N0 * Fe);
            %Génération du bruit gaussien à la bonne puissance en utilisant la fonction
            %randn de Matlab
            Bruit=sqrt(P_bruit)*randn(1,length(signal_emis_bpsk));
            %Ajout du bruit canal au signal émis => signal à l'entrée du récepteur
            signal_recu= signal_emis_bpsk + Bruit;

            dirac_tau0 = [1 zeros(1, Ns-1)]; %dirac en tau0 = 0
            dirac_tau1 = [zeros(1, Ns-1) 1]; %dirac en tau1 = Ts

            %filtrage multitrajet
            hc = alpha0*dirac_tau0 + alpha1*dirac_tau1; %réponse impulsionnelle du canal passe-bas équivalent au canal multitrajets
            signal_recu_bpsk = filter(hc,1,signal_recu);

            % Filtrage de réception
            hr = h;
            signal_recu_filtre_bpsk = filter(hr,1,signal_recu_bpsk);


            % Échantillonnage à n0 + mNs
            n0 = Ns;
            signal_bpsk = signal_recu_filtre_bpsk(n0:Ns:end);

            %symboles reçus
            symboles_recus = (signal_bpsk > 0) * 2 - 1;

            %bits reçus
            bits_recus = (symboles_recus + 1) / 2;

            % TEB cumulé
            TEB= TEB + (sum(bits_recus ~= bits)) / length(bits);
            % cumul erreurs et nombre de cumuls
            nb_erreurs = nb_erreurs + TEB * N;
            nb_cumul = nb_cumul+1;
        end
        %calcul du TEB
        TEB_bpsk(indice_bruit) = TEB / nb_cumul;
    end
end