## Partie 1 - Étude théorique

### Canal multitrajet
- [ ] Écrire l’expression de `ye(t)` en fonction de `xe(t)`, `α0`, `α1`, `τ0`, `τ1`
- [ ] En déduire la réponse impulsionnelle `hc(t)` du canal
- [ ] Choisir : `τ0 = 0`, `τ1 = Ts`, `α0 = 1`, `α1 = 0.5`

### Visualisations sans bruit
- [ ] Tracer le **signal en sortie du filtre de réception** `hr(t)` pour une séquence `011001`
- [ ] Tracer le **diagramme de l’œil** (sans bruit)
- [ ] Estimer la faisabilité du critère de Nyquist
- [ ] Calculer le **TEB théorique** avec détecteur à seuil
- [ ] Exprimer la puissance du bruit `σ²_w` en fonction de `N0` et `Ts`
- [ ] Exprimer l’énergie symbole `Es` et déduire `TEB(Eb/N0)`

## Partie 2 - Implantation MATLAB

### Paramètres initiaux
- [ ] Définir `Fe = 24000 Hz`, `Rb = 3000 bits/s`, `Ns = Fe / Rb`
- [ ] Définir les filtres d’émission/réception (porte ou racine de cosinus surélevé)

### Sans canal ni bruit (référence)
- [ ] Générer une séquence binaire aléatoire
- [ ] Moduler (BPSK)
- [ ] Filtrer (mise en forme)
- [ ] Démoduler et détecter
- [ ] Vérifier que le **TEB = 0**

### Avec canal multitrajet (sans bruit)
- [ ] Implémenter le canal `[1 0 0.5]` (délai en échantillons)
- [ ] Convoluer le signal avec le canal
- [ ] Visualiser :
  - [ ] Signal en sortie de `hr(t)` pour `011001`
  - [ ] Diagramme de l’œil
  - [ ] Constellation (en BPSK)

### Avec canal et bruit
- [ ] Ajouter un bruit blanc gaussien
- [ ] Mesurer le **TEB simulé** en fonction de `Eb/N0` (0 à 7 dB)
- [ ] Comparer avec le TEB **théorique**
- [ ] Comparer avec le cas sans canal (AWGN seul)

## Partie 3 - Égalisation

### Égaliseur ZFE
- [ ] Placer un Dirac en entrée
- [ ] Extraire la réponse impulsionnelle globale
- [ ] Résoudre le système pour obtenir les coefficients `C = [c0 c1 ... cN]`
- [ ] Filtrer avec l’égaliseur
- [ ] Visualiser :
  - [ ] Réponse en fréquence du canal, de l’égaliseur, et leur produit
  - [ ] Réponse impulsionnelle de la chaîne complète
  - [ ] Constellation avant/après égalisation
- [ ] Ajouter du bruit et tracer le **TEB avec ZFE**

### Égaliseur MMSE
- [ ] Générer une séquence d’apprentissage
- [ ] Calculer les corrélations auto et croisée
- [ ] En déduire `Copt = inv(Rzz) * Rza`
- [ ] Appliquer le filtre égaliseur
- [ ] Répéter les mêmes visualisations que pour ZFE
- [ ] Comparer le **TEB MMSE vs ZFE vs sans égalisation**

## Partie 4 - Analyse finale

- [ ] Comparer l’efficacité des deux égaliseurs
- [ ] Analyser les performances en **termes de TEB**
- [ ] Conclure sur l’impact du canal et de l’égalisation
- [ ] Soigner les figures (légendes, titres)
- [ ] Préparer le rapport/rendu final