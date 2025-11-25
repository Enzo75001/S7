# Fiche d'Exploitation - Alertes

| Alerte | Description | Sévérité | Impact | Remédiation |
| :--- | :--- | :--- | :--- | :--- |
| **HighErrorRate** | Taux d'erreurs 5xx > 2% sur 10m | Warning | Dégradation de l'expérience utilisateur, indisponibilité potentielle du service. | 1. Vérifier les logs de l'application (Loki).<br>2. Vérifier la charge (HPA).<br>3. Vérifier la connectivité avec la base de données (si applicable). |
| **PodHighRestarts** | > 5 redémarrages de pod sur 10m | Warning | Instabilité de l'application, crash loop possible. | 1. `kubectl describe pod <pod-name>` pour voir la raison du crash (OOMKilled, Error).<br>2. Vérifier les logs du pod précédent (`kubectl logs -p`).<br>3. Vérifier les limites de ressources. |
