function C = apprentissage_mmse(bits, signal_recu, Ns, N)
    % APPRENTISSAGE_MMSE : calcule les coefficients du filtre MMSE
    %
    % Entrées :
    %   bits        : vecteur binaire (1×Nb)
    %   signal_recu : vecteur suréchantillonné (1×L) en sortie du filtre Rx
    %   Ns          : facteur de suréchantillonnage
    %   N           : ordre du filtre (nombre de taps - 1)
    % Sortie :
    %   C           : vecteur (N+1)×1 des coefficients MMSE

    % Conversion en colonnes
    bits = bits(:);                      % Nb×1
    symboles = 2*bits - 1;               % mapping BPSK

    r = signal_recu(:);                  % vecteur colonne suréchantillonné

    Nb = length(symboles);
    L  = length(r);

    % Position du 1er échantillon utile = Ns
    n0 = Ns;

    % Nombre de vecteurs exploitables = Nb - N  (on tronque si besoin)
    M = Nb - N;
    if M <= 0
        error('Nb (%d) doit dépasser l’ordre N (%d) pour un apprentissage valide', Nb, N);
    end

    % Construire la matrice Z_all (M × (N+1))
    Z_all = zeros(M, N+1);
    for i = 1:M
        idx_center = n0 + (i+N-1)*Ns;  
        % Fenêtre glissante de longueur N+1 sur r :
        Z_all(i, :) = r(idx_center:-1:idx_center-N).';
    end

    % Vecteur des symboles alignés (on ignore les N premiers symboles)
    a_used = symboles(N+1: N+M);

    % Matrices de corrélation
    Rzz = (Z_all' * Z_all) / M;      % (N+1 × N+1)
    Rza = (Z_all' * a_used) / M;     % (N+1 × 1)

    % Résolution du système MMSE
    C = Rzz \ Rza;                   % (N+1 × 1)
end
