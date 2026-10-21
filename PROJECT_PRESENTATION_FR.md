# Présentations AD

## Introduction — 2 minutes
Je présente un laboratoire d’annuaire pour 200 employés synthétiques. J’ai codé le provisionnement et les diagnostics PowerShell, puis vérifié hors ligne leur syntaxe et leurs garde-fous. La topologie Windows Server et les exercices de reprise restent à déployer.

## Présentation technique — 5 minutes
Expliquer DC01/DC02, DNS, Kerberos, GC, OU, groupes AGDLP et FS01. Démontrer le CSV synthétique, `-WhatIf` et le rapport de tests. Montrer un runbook DNS et la méthode de validation.

## Défense de l’architecture — 10 minutes
Dérouler le flux CLIENT01 → DNS SRV → DC → ticket Kerberos → FS01, la segmentation, les modes de défaillance, la réplication et la sauvegarde. Reconnaître les compromis matériels et les preuves manquantes.

## Démonstration — 15 minutes
0–3 min: architecture; 3–7 min: module PowerShell et garde de domaine; 7–10 min: test CSV/Pester; 10–13 min: diagnostic DNS/GPO sur papier; 13–15 min: limites et prochaines étapes. N’exécuter des opérations AD réelles qu’après disponibilité d’un labo isolé.
