function C = apprentissage_mmse(bits, signal_recu, Ns, N)
    % apprentissage_mmse : Calcule les coefficients de l'égaliseur MMSE
    %
    % Entrées :
    %   - bits         : vecteur binaire transmis (0 ou 1)
    %   - signal_recu  : signal reçu suréchantillonné (en sortie du filtre de réception)
    %   - Ns           : facteur de suréchantillonnage (échantillons par symbole)
    %   - N            : ordre du filtre égaliseur (nombre de taps - 1)
    %
    % Sortie :
    %   - C            : coefficients du filtre égaliseur MMSE (colonne)

    % Mapping binaire centré
    symboles = 2*bits - 1;

    % Extraction des vecteurs z_n centrés sur les pics attendus
    n0 = Ns;  % position de l’échantillon optimal
    Nb = length(symboles);
    M = Nb - N;  % nombre d’exemples exploitables

    % Initialisation
    Z_all = zeros(M, N+1);  % chaque ligne = un vecteur z_n
    for i = 1:M
        debut = n0 + (i+N-1)*Ns;
        if debut > length(signal_recu)
            break;  % protection contre dépassement
        end
        Z_all(i, :) = signal_recu(debut:-1:debut-N);
    end

    a_used = symboles(N+1:N+M).';  % vecteur colonne

    % Calculs statistiques
    Rzz = (Z_all') * Z_all / M;
    Rza = (Z_all') * a_used / M;

    % Conditionnement pour info
    fprintf("Conditionnement de Rzz : %.2e\n", cond(Rzz));

    % Résolution MMSE
    C = Rzz \ Rza;
end
