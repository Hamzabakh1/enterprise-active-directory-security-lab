# Défense de l’architecture AD

**Pourquoi deux DC ?** Résilience DNS/Kerberos/GC avec réplication contrôlée; le second DC ne remplace ni sauvegarde ni reprise de forêt.

**Pourquoi quatre segments ?** Réduire les chemins latéraux; MGMT01 concentre les accès d’administration, CLIENT01 n’administre pas les DC.

**Pourquoi AGDLP ?** Changer les personnes dans des groupes globaux sans réécrire les ACL des ressources.

**Compromis :** davantage de VMs, ports et surveillance; le poste actuel ne peut pas prouver le comportement réel.

**Validation attendue :** DNS SRV depuis CLIENT01, `dcdiag`, `repadmin`, `gpresult`, tests d’accès FS01, restauration System State. Aucun de ces résultats n’a été exécuté ici.
