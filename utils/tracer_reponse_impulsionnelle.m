function tracer_reponse_impulsionnelle(hc, C)
    % tracer_reponse_impulsionnelle : Affiche les réponses impulsionnelles
    % Entrées :
    %   hc : vecteur réponse impulsionnelle du canal (1×Lhc)
    %   C  : vecteur coefficients du filtre égaliseur MMSE (1×(N+1) ou (N+1)×1)
    %
    % Tracé :
    %   • stem(hc)       en bleu
    %   • stem(C)        en rouge   (aligné au même échelle)
    %   • stem(h_eq)     en vert    (h_eq = conv(hc, C))
    %

    % S’assurer que hc et C sont des vecteurs colonnes
    hc = hc(:);
    C  = C(:);

    % Calcul de la réponse impulsionnelle de la chaîne égalisée
    h_eq = conv(hc, C);

    % Préparer le figure
    stem_indices = @(x) (0:length(x)-1);  % indices 0,1,2,...

    figure;
    hold on;

    % Canal
    stem(stem_indices(hc), hc, 'b', 'filled', 'DisplayName', 'Canal (hc)');

    % Égaliseur : on aligne le centre du filtre sur l’indice 0
    % Pour une meilleure visibilité, on peut décaler l’égaliseur de -(N/2)
    N = length(C) - 1;
    % Ici on choisit de centrer C en décalant de N/2 vers la gauche
    dec = floor(N/2);
    stem(stem_indices(C) - dec, C, 'r', 'filled', 'DisplayName', 'Égaliseur (C)');

    % Chaîne égalisée
    stem(stem_indices(h_eq), h_eq, 'g', 'filled', 'DisplayName', 'Chaîne égalisée (hc * C)');

    xlabel('Échantillons');
    ylabel('Amplitude');
    title('Réponses impulsionnelles');
    legend('Location','best');
    grid on;
    hold off;
end
