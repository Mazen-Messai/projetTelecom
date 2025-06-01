function y_equal = egaliseur_mmse(r_sampled, C)
    % egaliseur_mmse : Applique le filtre égaliseur MMSE aux symboles reçus
    %
    % Entrées :
    %   r_sampled : vecteur des symboles BPSK reçus (1 point/symbole), taille L×1 ou 1×L
    %   C          : vecteur colonnes des coefficients MMSE, taille (N+1)×1
    %
    % Sortie :
    %   y_equal    : vecteur des symboles égalisés, taille (L−N)×1
    %

    % Forcer en vecteur colonne
    r = r_sampled(:);
    C = C(:);

    % Ordre du filtre
    N = length(C) - 1;

    % Nombre de symboles exploitables après glissement
    L = length(r);
    if L <= N
        error('Le vecteur r_sampled doit contenir strictement plus de %d échantillons', N);
    end
    M = L - N;

    % Construction de la matrice de fenêtres glissantes
    % Chaque ligne i contient [r(i+N), r(i+N-1), ..., r(i)].
    Z = zeros(M, N+1);
    for i = 1:M
        Z(i, :) = r(i+N:-1:i).';
    end

    % Application du filtre : y_equal(i) = C' * [r(i+N); ...; r(i)]
    y_equal = Z * C;

    % Optionnel : si tu veux retourner des décisions binaires (0/1), décommente :
    % y_est_bits = real(y_equal) > 0;  % seuil à 0 pour BPSK
    % y_equal = 2*y_est_bits - 1;      % remap en ±1
end
