# Cas de dépannage AD

1. **Connexion impossible, DNS externe** — vérifier `ipconfig /all`, SRV et `nltest`; restaurer les DNS DC; tester le login.
2. **GPO absente** — contrôler OU, liens, filtres et `gpresult`; corriger le ciblage; vérifier le paramètre appliqué.
3. **Réplication en échec** — corréler `repadmin`, DNS, RPC, temps et journaux; rétablir le chemin; valider un objet sur les deux DC.
4. **Accès FS01 refusé** — comparer groupes, ACL du partage et NTFS, ticket Kerberos; restaurer la règle approuvée; tester avec deux comptes.
5. **DC01 indisponible** — confirmer DC02, DNS, GC et authentification; restaurer DC01 si possible sans saisie prématurée des FSMO.

Chaque incident doit être joué uniquement dans un laboratoire isolé et consigné avec état initial, impact, commandes, cause, correction, résultat et prévention. Voir les [runbooks détaillés](TROUBLESHOOTING.md).
