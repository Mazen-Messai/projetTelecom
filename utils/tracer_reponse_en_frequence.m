function tracer_reponse_en_frequence(hc, C)
    % tracer_reponse_en_frequence : Affiche les réponses fréquentielles du canal, de l’égaliseur et de la chaîne
    % Entrées :
    %   hc : vecteur réponse impulsionnelle du canal (1×Lhc ou Lhc×1)
    %   C  : vecteur coefficients du filtre égaliseur MMSE ((N+1)×1 ou 1×(N+1))
    %
    % Tracé :
    %   • |H_c|             en bleu
    %   • |H_eq|            en rouge
    %   • |H_c × H_eq|      en vert

    % Taille de la FFT pour une bonne résolution
    Nfft = 512;

    % Forcer en vecteurs colonnes
    hc = hc(:);
    C  = C(:);

    % Calcul des spectres (normés)
    Hc   = abs(fft(ones(length(hc)), Nfft));
    Heq  = abs(fft(C,  Nfft));
    Htot = Hc .* Heq;

    % Axe des fréquences normalisées (0 à 1 = 0 à Fs/2)
    f = linspace(0, 1, Nfft);

    % Normalisation pour affichage (échelle à 1 au maximum)
    Hc_norm   = Hc   / max(Hc);
    Heq_norm  = Heq  / max(Heq);
    Htot_norm = Htot / max(Htot);

    % Tracé
    plot(f, Hc_norm,   'b-', 'LineWidth', 1.5, 'DisplayName', 'Canal (|H_c|)');
    hold on;
    plot(f, Heq_norm,  'r-', 'LineWidth', 1.5, 'DisplayName', 'Égaliseur (|H_{eq}|)');
    plot(f, Htot_norm, 'g-', 'LineWidth', 1.5, 'DisplayName', 'Chaîne égalisée (|H_c \times H_{eq}|)');

    xlabel('Fréquence normalisée');
    ylabel('Amplitude normalisée');
    title('Réponses fréquentielles normalisées');
    legend('Location','best');
    grid on;
    hold off;
end
