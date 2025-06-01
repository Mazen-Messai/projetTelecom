function TEB = evaluer_teb(symboles_tx, symboles_rx)
    % EVALUER_TEB : calcule le TEB en comparant deux vecteurs BPSK
    %
    %   symboles_tx : vecteur (±1) transmis
    %   symboles_rx : vecteur (±1 ou valeurs réelles/complexes à seuiler)
    %
    % Le seuillage se fait automatiquement à 0 (BPSK). Si symboles_rx
    % est complexe, on ne garde que la partie réelle.

    tx = symboles_tx(:);
    rx = symboles_rx(:);

    % Seuillage pour BPSK
    rx_demod = (real(rx) > 0)*2 - 1;

    % Tronquer à la même longueur si besoin
    Lmin = min(length(tx), length(rx_demod));
    tx = tx(1:Lmin);
    rx_demod = rx_demod(1:Lmin);

    % Calcul du TEB
    TEB = sum(tx ~= rx_demod) / Lmin;
end
