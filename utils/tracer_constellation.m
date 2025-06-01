function tracer_constellation(vecteur_rx, modulation_type, M)
    % TRACER_CONSTELLATION : trace la constellation d'un vecteur reçu
    %
    % Entrées :
    %   vecteur_rx       : vecteur (complexe) reçu (1×L ou L×1)
    %   modulation_type  : 'PSK' ou 'QAM'
    %   M                : ordre de la modulation (ex. 2 pour BPSK, 16 pour 16-QAM)

    rx = vecteur_rx(:);

    % Points de référence
    switch modulation_type
        case 'PSK'
            ref = pskmod(0:M-1, M);   % points M-PSK
        case 'QAM'
            ref = qammod(0:M-1, M);   % points M-QAM
        otherwise
            error('Modulation "%s" non supportée (PSK/QAM seulement).', modulation_type);
    end

    % Normalisation
    ref        = ref / max(abs(ref));
    rx         = rx / max(abs(rx));

    % Tracé
    plot(real(rx), imag(rx), 'b.', 'MarkerSize', 10, 'DisplayName','Reçu');
    hold on;
    plot(real(ref), imag(ref), 'ro', 'MarkerSize', 8, 'LineWidth', 1.5, ...
        'DisplayName','Théorique');
    grid on; axis equal;
    xlabel('Re\{y\}'); ylabel('Im\{y\}');
    title(sprintf('Constellation %s-%d', modulation_type, M));
    legend('Location','best');
    hold off;
end
