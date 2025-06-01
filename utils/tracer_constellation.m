function plot_constellation(signal_rx, modulation_type, M)
    % plot_constellation : Trace la constellation d'un signal reçu
    %
    % Entrées :
    %   - signal_rx : signal reçu (vecteur complexe)
    %   - modulation_type : 'PSK' ou 'QAM'
    %   - M : ordre de modulation (ex: 2, 4, 8, 16)

    % Vérif des entrées
    if ~ismember(modulation_type, {'PSK', 'QAM'})
        error('Modulation non supportée. Choisissez ''PSK'' ou ''QAM''.');
    end
    
    % Création des points théoriques de la constellation
    switch modulation_type
        case 'PSK'
            ref = pskmod(0:M-1, M);  % Points de référence
        case 'QAM'
            ref = qammod(0:M-1, M);  % Points de référence
    end

    % Normalisation si nécessaire (utile pour comparaison PSK/QAM)
    ref = ref / max(abs(ref));
    signal_rx = signal_rx / max(abs(signal_rx));

    % Tracé
    figure;
    plot(real(signal_rx), imag(signal_rx), 'b.', 'DisplayName', 'Signal reçu');
    hold on;
    plot(real(ref), imag(ref), 'ro', 'MarkerSize', 8, 'LineWidth', 1.5, ...
        'DisplayName', 'Constellation théorique');
    grid on;
    axis equal;
    xlabel('Re');
    ylabel('Im');
    title(sprintf('Constellation %s-%d', modulation_type, M));
    legend;
end
