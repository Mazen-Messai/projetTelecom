# Projet Telecom

## Structure du projet
projetTelecom/
├── main.m
├── README.md
├── TODO.md
├── signal/
│ ├── generer_signal.m # Génère une séquence binaire à transmettre
│ └── modulation_bpsk.m # Module en BPSK si tu veux séparer l'étape
├── canaux/
│ ├── appliquer_mutlitrajet.m # Applique le canal multitrajet (convolution)
│ └── ajouter_bruit.m # Ajoute un bruit AWGN selon le SNR
├── egualiseur/
│ ├── egualiseur_zf.m # Implémente un égaliseur ZF
│ ├── egualiseur_mmse.m # Implémente un égaliseur MMSE
│ └── calculer_coefficients.m # Calcule les coefficients à partir d’un dirac ou d’une séquence d’apprentissage
├── analyse/
│ ├── evaluer_teb.m # Calcule le TEB en comparant le signal transmis et reçu
│ └── comparer_courbe_teb.m # Trace et compare les courbes BER avec/sans égalisation
├── utils/
│ ├── tracer_diagramme_oeil.m # Affiche le diagramme de l’œil
│ ├── tracer_constellation.m # Affiche la constellation BPSK reçue
│ └── tracer_signaux.m # Visualise les signaux à différents points de la chaîne
└── data/ # Dossier ou on stocke toute les données, il vaut mieux essayer de tout enregistrer.
