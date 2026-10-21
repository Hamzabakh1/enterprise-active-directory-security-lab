# Prise en main de DC01 dans VirtualBox

**État vérifié le 21 octobre 2026 :** Windows Server 2025 Standard Evaluation (Server Core) est installé dans `Atlas-DC01`. La dernière capture directe de la VM montre encore l'écran « Press Ctrl-Alt-Del to unlock ». Le nom Windows, l'adresse IP et la forêt Active Directory ne sont pas encore vérifiés. Les étapes ci-dessous sont à exécuter **dans la VM**, une fois la session Administrateur ouverte. Ne saisissez jamais un mot de passe dans le dépôt ou dans une conversation.

## 1. Ouvrir la session

Dans la fenêtre `Atlas-DC01`, choisissez **Entrée → Clavier → Insérer Ctrl-Alt-Suppr**, puis ouvrez la session avec le mot de passe actuel, directement dans la VM. Après connexion, Server Core lance normalement **SConfig**. Vérifiez que le nom de l'ordinateur et les paramètres réseau apparaissent à l'écran.

## 2. Configurer le réseau isolé

La carte VirtualBox est raccordée au réseau interne `atlas-lab` : elle n'a ni routeur ni accès Internet. Le plan privé de ce pilote est `10.77.10.0/24`, avec `10.77.10.10` pour DC01. Dans SConfig :

1. Choisissez **8 — Network Settings**, puis le numéro de la carte connectée.
2. Choisissez **1 — Set Network Adapter Address**, puis **S — Static IP**.
3. Saisissez `10.77.10.10`, masque `255.255.255.0`. Laissez la passerelle vide si SConfig l'accepte. Si le formulaire impose une passerelle, arrêtez-vous et signalez-le : n'inventez pas une route vers le réseau personnel.
4. Choisissez **2 — Set DNS Servers** et utilisez `10.77.10.10` comme DNS préféré. Aucun DNS public ni DNS secondaire n'est nécessaire tant que DC01 est seul.
5. Revenez au menu principal et vérifiez l'adresse affichée. Ce plan privé remplace les adresses `192.0.2.x` de la documentation de référence, réservées aux exemples.

## 3. Nommer le serveur

Dans SConfig, choisissez **2 — Computer Name**, saisissez `DC01`, puis acceptez le redémarrage. Après redémarrage, ouvrez de nouveau la session et vérifiez que le menu affiche `DC01` et `10.77.10.10`.

## 4. Installer la première forêt, après vérification

Le script versionné [`scripts/installation/Install-DC01.ps1`](scripts/installation/Install-DC01.ps1) installe le rôle AD DS et crée la forêt isolée `corp.example.test`. Il exige `-ApprovedLab`, le nom Windows exact `DC01`, puis une confirmation interactive. Le mot de passe de restauration DSRM est saisi localement et ne doit pas être enregistré. Avant de l'exécuter, vérifiez le nom, l'adresse et l'isolement de la VM ; lancez d'abord le script avec `-WhatIf`. Le fichier du dépôt doit être transféré dans la VM avant exécution : son chemin sur l'hôte n'est pas un chemin Windows dans le serveur invité.

Après promotion et redémarrage, validez `Get-ADDomain`, `Get-DnsServerZone`, les partages `SYSVOL` et `NETLOGON`, puis `dcdiag`. Conservez les captures d'écran uniquement après avoir vérifié qu'elles ne contiennent pas de secrets.

La [documentation Microsoft de SConfig](https://learn.microsoft.com/en-us/windows-server/administration/server-core/server-core-sconfig) décrit les menus 2 et 8. La [documentation Microsoft d'AD DS](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/deploy/install-active-directory-domain-services--level-100-) décrit la création d'une forêt Windows Server 2025.
