# 30 questions techniques — Active Directory

Statut: préparation d’entretien. Les exemples d’infrastructure sont conceptuels; seuls les tests hors ligne consignés dans `VALIDATION_REPORT.md` ont été exécutés.

## 1. Pourquoi deux contrôleurs de domaine ?

**Question du jury :** Pourquoi deux contrôleurs de domaine ?

**Réponse technique :** Ils réduisent le point unique de défaillance pour LDAP, Kerberos, DNS et GC.

**Explication détaillée :** La disponibilité suppose des sites, DNS clients et une réplication sains. Deux DC incohérents peuvent aggraver un incident.

**Exemple pratique :** DC01 indisponible, CLIENT01 doit trouver DC02.

**Commandes pertinentes :** `Get-ADDomainController -Filter *; repadmin /replsummary`

**Pièges à éviter :** Confondre redondance et sauvegarde.

**Question de relance possible :** Quel critère justifie un troisième DC ?

## 2. Comment un client localise-t-il un DC ?

**Question du jury :** Comment un client localise-t-il un DC ?

**Réponse technique :** Il interroge des enregistrements SRV DNS puis applique la logique de site DC Locator.

**Explication détaillée :** Un résolveur public ne connaît pas la zone AD; la connectivité IP seule ne suffit pas.

**Exemple pratique :** CLIENT01 utilise les DNS DC01 et DC02.

**Commandes pertinentes :** `Resolve-DnsName _ldap._tcp.dc._msdcs.corp.example.test -Type SRV; nltest /dsgetdc:corp.example.test`

**Pièges à éviter :** Diagnostiquer Kerberos avant de vérifier DNS.

**Question de relance possible :** Comment forcer le site AD attendu ?

## 3. Quel rôle joue Kerberos ?

**Question du jury :** Quel rôle joue Kerberos ?

**Réponse technique :** Il délivre des tickets TGT puis des tickets de service via le KDC du DC.

**Explication détaillée :** L’horloge, le SPN, DNS et les clés du compte influencent le résultat.

**Exemple pratique :** Accès SMB à FS01 avec un ticket cifs/FS01.

**Commandes pertinentes :** `klist; setspn -L FS01`

**Pièges à éviter :** Supposer qu’un échec SMB est uniquement une ACL.

**Question de relance possible :** Que se passe-t-il en cas de décalage horaire ?

## 4. Quand LDAP intervient-il ?

**Question du jury :** Quand LDAP intervient-il ?

**Réponse technique :** LDAP lit et modifie des objets annuaire selon les droits.

**Explication détaillée :** Kerberos authentifie; LDAP fournit les attributs et recherches. LDAPS ou protections de liaison peuvent sécuriser le transport.

**Exemple pratique :** Recherche d’un utilisateur et de ses groupes.

**Commandes pertinentes :** `Get-ADUser lab.amal.atlas -Properties Department`

**Pièges à éviter :** Assimiler LDAP à l’authentification elle-même.

**Question de relance possible :** Comment durcir la liaison LDAP ?

## 5. Pourquoi un Global Catalog ?

**Question du jury :** Pourquoi un Global Catalog ?

**Réponse technique :** Il permet les recherches forêt et certaines résolutions de groupes universels.

**Explication détaillée :** Dans un domaine unique il simplifie la résilience, mais la réplication doit rester saine.

**Exemple pratique :** DC01 et DC02 sont prévus GC.

**Commandes pertinentes :** `Get-ADDomainController -Filter * | Select HostName,IsGlobalCatalog`

**Pièges à éviter :** Ne pas vérifier le GC après promotion.

**Question de relance possible :** Quel impact pour un domaine multi-domaines ?

## 6. Comment concevoir les OU ?

**Question du jury :** Comment concevoir les OU ?

**Réponse technique :** Les OU structurent délégation et ciblage GPO, pas la frontière de sécurité ultime.

**Explication détaillée :** La hiérarchie suit les opérations et évite des liens GPO ambigus.

**Exemple pratique :** OU IT, Finance, Workstations, Servers et Groups.

**Commandes pertinentes :** `Get-ADOrganizationalUnit -Filter *`

**Pièges à éviter :** Créer une OU par application sans besoin opérationnel.

**Question de relance possible :** Comment déléguer un reset de mot de passe ?

## 7. Que signifie AGDLP ?

**Question du jury :** Que signifie AGDLP ?

**Réponse technique :** Accounts → Global groups → Domain Local groups → Permissions.

**Explication détaillée :** Cette séparation réduit les ACL directement liées aux comptes et facilite les changements de rôle.

**Exemple pratique :** GG-Finance-Users membre de DL-FS01-Finance-Read.

**Commandes pertinentes :** `Get-ADGroupMember GG-Finance-Users`

**Pièges à éviter :** Attribuer les droits directement à chaque utilisateur.

**Question de relance possible :** Comment adapter AGDLP en forêt multiple ?

## 8. Comment provisionner 200 comptes ?

**Question du jury :** Comment provisionner 200 comptes ?

**Réponse technique :** Valider les données, tester avec WhatIf, créer les comptes puis contrôler les groupes.

**Explication détaillée :** Une opération idempotente évite les doublons; le mot de passe initial doit rester hors CSV.

**Exemple pratique :** Import de six personnes synthétiques avant extension à 200.

**Commandes pertinentes :** `Import-AtlasUsers -CsvPath .\users.csv -InitialPassword $secret -WhatIf`

**Pièges à éviter :** Mettre un mot de passe en clair dans Git.

**Question de relance possible :** Comment gérer une erreur à mi-import ?

## 9. Quelle différence entre GPO et stratégie de mot de passe ?

**Question du jury :** Quelle différence entre GPO et stratégie de mot de passe ?

**Réponse technique :** La stratégie du domaine et les fine-grained password policies gèrent les comptes du domaine.

**Explication détaillée :** Une GPO liée à une OU de postes ne définit pas la politique des comptes du domaine.

**Exemple pratique :** Politique plus forte pour comptes privilégiés via PSO.

**Commandes pertinentes :** `Get-ADDefaultDomainPasswordPolicy; Get-ADFineGrainedPasswordPolicy -Filter *`

**Pièges à éviter :** Chercher la politique effective uniquement dans gpresult.

**Question de relance possible :** Comment déterminer la PSO résultante ?

## 10. Comment diagnostiquer une GPO absente ?

**Question du jury :** Comment diagnostiquer une GPO absente ?

**Réponse technique :** Vérifier OU, lien, héritage, filtrage, WMI, SYSVOL et résultat côté client.

**Explication détaillée :** Un gpupdate réussi ne prouve pas qu’une GPO précise est applicable.

**Exemple pratique :** CLIENT01 déplacé hors de l’OU ciblée.

**Commandes pertinentes :** `gpresult /h result.html; Get-GPInheritance`

**Pièges à éviter :** Relier la GPO au domaine pour masquer une erreur de ciblage.

**Question de relance possible :** Comment voir un refus de filtrage ?

## 11. Pourquoi SYSVOL est-il critique ?

**Question du jury :** Pourquoi SYSVOL est-il critique ?

**Réponse technique :** Il transporte scripts et fichiers de stratégie pour les GPO.

**Explication détaillée :** Un AD répliqué avec SYSVOL défaillant peut produire des politiques incohérentes.

**Exemple pratique :** Comparer la présence du dossier de GPO sur DC01 et DC02.

**Commandes pertinentes :** `Get-SmbShare; dfsrdiag backlog`

**Pièges à éviter :** Considérer la seule réplication AD comme preuve suffisante.

**Question de relance possible :** Comment identifier un backlog DFSR ?

## 12. Comment valider la réplication ?

**Question du jury :** Comment valider la réplication ?

**Réponse technique :** Comparer résumés, partenaires, derniers succès et objets tests.

**Explication détaillée :** Un résultat ponctuel doit être corrélé aux journaux et au temps écoulé depuis la dernière réussite.

**Exemple pratique :** Créer un objet test puis rechercher sur chaque DC.

**Commandes pertinentes :** `repadmin /replsummary; repadmin /showrepl`

**Pièges à éviter :** Lancer une synchronisation forcée sans connaître la cause.

**Question de relance possible :** Quels ports et DNS vérifier ?

## 13. Quels sont les cinq rôles FSMO ?

**Question du jury :** Quels sont les cinq rôles FSMO ?

**Réponse technique :** Schema Master, Domain Naming Master, PDC Emulator, RID Master et Infrastructure Master.

**Explication détaillée :** Les deux premiers sont forêt; les trois autres sont domaine. Le PDC influence temps et changements de mot de passe.

**Exemple pratique :** Documenter leurs détenteurs avant maintenance.

**Commandes pertinentes :** `netdom query fsmo; Get-AtlasFSMORoles`

**Pièges à éviter :** Saisir un rôle pour une simple panne temporaire.

**Question de relance possible :** Quand un transfert devient-il une saisie ?

## 14. Quand saisir un rôle FSMO ?

**Question du jury :** Quand saisir un rôle FSMO ?

**Réponse technique :** Seulement si l’ancien détenteur est définitivement perdu et ne reviendra pas.

**Explication détaillée :** Une saisie exige un plan de nettoyage des métadonnées et de reconstruction.

**Exemple pratique :** DC01 détruit sans possibilité de restauration.

**Commandes pertinentes :** `Move-ADDirectoryServerOperationMasterRole -Identity DC02 -OperationMasterRole PDCEmulator -Force`

**Pièges à éviter :** Remettre en ligne l’ancien détenteur après saisie.

**Question de relance possible :** Quelles précautions pour Schema Master ?

## 15. Comment diagnostiquer un compte inactif ?

**Question du jury :** Comment diagnostiquer un compte inactif ?

**Réponse technique :** Croiser plusieurs signaux de connexion, statut et contexte métier.

**Explication détaillée :** LastLogonDate est répliqué avec retard et n’est pas un déclencheur sûr à lui seul.

**Exemple pratique :** Rapport sur comptes synthétiques sans désactivation automatique.

**Commandes pertinentes :** `Get-AtlasInactiveAccounts -Days 90`

**Pièges à éviter :** Désactiver immédiatement tout compte sans date.

**Question de relance possible :** Quelle source donne un dernier logon précis ?

## 16. Comment déléguer sans Domain Admin ?

**Question du jury :** Comment déléguer sans Domain Admin ?

**Réponse technique :** Déléguer des droits ciblés sur une OU à un groupe dédié et vérifier les refus hors périmètre.

**Explication détaillée :** La délégation se contrôle via ACL d’objet et tests avec un compte non privilégié.

**Exemple pratique :** Helpdesk peut réinitialiser les comptes IT de test uniquement.

**Commandes pertinentes :** `dsacls "OU=IT,DC=corp,DC=example,DC=test"`

**Pièges à éviter :** Accorder GenericAll au niveau domaine.

**Question de relance possible :** Comment auditer la délégation ?

## 17. Quelle différence entre share et NTFS ?

**Question du jury :** Quelle différence entre share et NTFS ?

**Réponse technique :** L’accès réseau est contraint par les deux; le plus restrictif s’applique.

**Explication détaillée :** Une appartenance de groupe ne suffit pas si une ACL ou un deny bloque.

**Exemple pratique :** Tester une lecture autorisée et une écriture refusée sur FS01.

**Commandes pertinentes :** `Get-SmbShareAccess -Name Finance; Get-Acl D:\Shares\Finance`

**Pièges à éviter :** Modifier uniquement la permission du partage.

**Question de relance possible :** Comment inspecter l’accès effectif ?

## 18. Comment fonctionne DNS intégré à AD ?

**Question du jury :** Comment fonctionne DNS intégré à AD ?

**Réponse technique :** Les zones peuvent être stockées dans des partitions AD et répliquées selon leur portée.

**Explication détaillée :** Les mises à jour dynamiques sécurisées protègent les enregistrements des membres.

**Exemple pratique :** Contrôler les SRV sur DC01 puis DC02.

**Commandes pertinentes :** `Get-DnsServerZone; Resolve-DnsName -Server DC02 corp.example.test`

**Pièges à éviter :** Créer une zone primaire indépendante sur chaque DC.

**Question de relance possible :** Quel périmètre de réplication choisir ?

## 19. Pourquoi DHCP doit-il fournir les bons DNS ?

**Question du jury :** Pourquoi DHCP doit-il fournir les bons DNS ?

**Réponse technique :** Les clients AD doivent résoudre les SRV internes pour localiser le domaine.

**Explication détaillée :** Les options 006 et 015 sont vérifiées depuis la machine cliente, pas seulement dans la console DHCP.

**Exemple pratique :** CLIENT01 reçoit DC01/DC02, puis renouvelle son bail.

**Commandes pertinentes :** `ipconfig /all; Get-DhcpServerv4OptionValue`

**Pièges à éviter :** Distribuer 8.8.8.8 comme DNS secondaire.

**Question de relance possible :** Comment détecter un DHCP rogue ?

## 20. Quelles vérifications après promotion DC ?

**Question du jury :** Quelles vérifications après promotion DC ?

**Réponse technique :** Vérifier DNS, GC, SYSVOL, NETLOGON, réplication et journaux.

**Explication détaillée :** La réussite de l’assistant de promotion est une étape, pas une preuve de service.

**Exemple pratique :** DC02 doit répondre aux SRV et recevoir un objet test.

**Commandes pertinentes :** `dcdiag /e /c; repadmin /replsummary`

**Pièges à éviter :** Arrêter après le premier reboot.

**Question de relance possible :** Quels événements analyser ?

## 21. Comment préparer une restauration AD ?

**Question du jury :** Comment préparer une restauration AD ?

**Réponse technique :** Disposer de sauvegardes System State protégées et d’un exercice documenté.

**Explication détaillée :** Le RPO/RTO se mesure pendant des essais; un snapshot VM seul ne remplace pas la sauvegarde.

**Exemple pratique :** Restaurer DC02 dans un clone isolé.

**Commandes pertinentes :** `wbadmin get versions`

**Pièges à éviter :** Promettre un RTO sans exercice.

**Question de relance possible :** Quand choisir AD Recycle Bin ?

## 22. Restore autoritaire ou non autoritaire ?

**Question du jury :** Restore autoritaire ou non autoritaire ?

**Réponse technique :** Non autoritaire pour un DC à resynchroniser; autoritaire pour imposer la restauration d’objets ciblés.

**Explication détaillée :** Le mode autoritaire doit être coordonné avec la réplication et réalisé uniquement après analyse.

**Exemple pratique :** Objet supprimé: vérifier d’abord AD Recycle Bin.

**Commandes pertinentes :** `Get-ADOptionalFeature "Recycle Bin Feature"`

**Pièges à éviter :** Appliquer une restauration autoritaire à toute panne.

**Question de relance possible :** Comment tester le résultat sur les deux DC ?

## 23. Que faire si DC01 tombe ?

**Question du jury :** Que faire si DC01 tombe ?

**Réponse technique :** Confirmer DC02, DNS, authentification, réplication et détenteurs FSMO.

**Explication détaillée :** Une panne transitoire ne justifie pas une saisie FSMO. La remise en ligne exige vérification d’intégrité.

**Exemple pratique :** CLIENT01 se connecte via DC02.

**Commandes pertinentes :** `nltest /dsgetdc:corp.example.test; Get-AtlasDomainHealth`

**Pièges à éviter :** Recréer DC01 avant diagnostic.

**Question de relance possible :** Comment gérer un DC perdu définitivement ?

## 24. Comment sécuriser les comptes de service ?

**Question du jury :** Comment sécuriser les comptes de service ?

**Réponse technique :** Utiliser gMSA quand compatible, droits minimaux et rotation automatique.

**Explication détaillée :** Ils ne doivent pas partager les privilèges Domain Admin et leurs SPN doivent être inventoriés.

**Exemple pratique :** Service FS01 utilise une gMSA dédiée.

**Commandes pertinentes :** `Get-ADServiceAccount -Filter *`

**Pièges à éviter :** Mot de passe statique stocké dans un script.

**Question de relance possible :** Quels prérequis pour gMSA ?

## 25. Comment durcir les admins ?

**Question du jury :** Comment durcir les admins ?

**Réponse technique :** Séparer identités standard et privilégiées, limiter les postes d’administration et surveiller les groupes.

**Explication détaillée :** Le segment MGMT01 sert de chemin d’administration contrôlé; MFA ne remplace pas la segmentation locale.

**Exemple pratique :** Compte admin ne se connecte pas à CLIENT01.

**Commandes pertinentes :** `Get-AtlasPrivilegedMembership`

**Pièges à éviter :** Utiliser Domain Admin pour les tâches ordinaires.

**Question de relance possible :** Comment limiter le vol de tickets ?

## 26. Quels journaux pour une enquête de connexion ?

**Question du jury :** Quels journaux pour une enquête de connexion ?

**Réponse technique :** Corréler événements de sécurité, Kerberos, Netlogon, DNS et horodatage client/DC.

**Explication détaillée :** Un seul code événement isolé peut induire en erreur; le contexte du contrôleur contacté compte.

**Exemple pratique :** Échec de connexion de lab.amal.atlas après mauvais DNS.

**Commandes pertinentes :** `Get-WinEvent -LogName Security -MaxEvents 50`

**Pièges à éviter :** Désactiver l’audit à cause du volume.

**Question de relance possible :** Comment centraliser et protéger les journaux ?

## 27. Comment valider les permissions d’un fichier ?

**Question du jury :** Comment valider les permissions d’un fichier ?

**Réponse technique :** Comparer appartenance, ticket, droits share, ACL NTFS et test réel avec identité synthétique.

**Explication détaillée :** La sortie ACL seule ne calcule pas toutes les règles effectives et héritées.

**Exemple pratique :** Finance lecture autorisée, Engineering refus.

**Commandes pertinentes :** `whoami /groups; Get-AtlasFileAccess -Path D:\Shares\Finance -IdentityReference CORP\DL-Finance-Read`

**Pièges à éviter :** Tester seulement avec un administrateur.

**Question de relance possible :** Quel effet d’un deny explicite ?

## 28. Comment contrôler l’heure du domaine ?

**Question du jury :** Comment contrôler l’heure du domaine ?

**Réponse technique :** PDC Emulator suit une source fiable; les autres DC et clients suivent la hiérarchie.

**Explication détaillée :** Un écart d’horloge perturbe Kerberos et la réplication.

**Exemple pratique :** Comparer CLIENT01, DC01 et DC02.

**Commandes pertinentes :** `w32tm /query /status; w32tm /monitor`

**Pièges à éviter :** Configurer une source Internet différente sur chaque DC.

**Question de relance possible :** Quel impact d’une dérive de cinq minutes ?

## 29. Comment auditer les groupes privilégiés ?

**Question du jury :** Comment auditer les groupes privilégiés ?

**Réponse technique :** Lister membres récursifs, comparer à une base approuvée et alerter sur les changements.

**Explication détaillée :** La récursivité et les SID intégrés comptent; le nom affiché peut varier selon la langue.

**Exemple pratique :** Ajouter un compte lab puis confirmer l’alerte dans un exercice.

**Commandes pertinentes :** `Get-AtlasPrivilegedMembership`

**Pièges à éviter :** Se limiter à Domain Admins.

**Question de relance possible :** Quels groupes sont forest-wide ?

## 30. Comment présenter ce laboratoire sans surpromettre ?

**Question du jury :** Comment présenter ce laboratoire sans surpromettre ?

**Réponse technique :** Distinguer code testé hors ligne, architecture documentée et opérations AD non exécutées.

**Explication détaillée :** Une preuve d’entretien doit relier commande, environnement, résultat et capture authentique.

**Exemple pratique :** Montrer le module et le rapport Pester, puis exposer les prérequis VM.

**Commandes pertinentes :** `Invoke-Pester .\tests\AtlasAD.Tests.ps1`

**Pièges à éviter :** Dire que la réplication fonctionne sans DC.

**Question de relance possible :** Quelle prochaine validation augmente la crédibilité ?
