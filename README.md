# S7 — Observabilité : Logs, Métriques, Traces

Ce dossier contient les livrables pour le module S7, dédié à la mise en place d'une stack d'observabilité complète sur Kubernetes.

## Objectifs

*   **Métriques** : Collecte et visualisation avec Prometheus et Grafana.
*   **Logs** : Centralisation des logs avec Loki et Promtail.
*   **Traces** : Traçage distribué avec Jaeger.
*   **Alerting** : Définition de règles d'alerte pour la supervision applicative.

## Prérequis

*   Un cluster Kubernetes (ex: Minikube).
*   `kubectl` et `helm` installés.
*   `cert-manager` (installé automatiquement par le script, ou pré-installé).

## Installation

Un script d'installation automatisé est fourni pour déployer la stack complète.

1.  **Rendre le script exécutable** :
    ```bash
    chmod +x install_stack.sh
    ```

2.  **Lancer l'installation** :
    ```bash
    ./install_stack.sh
    ```
    *Ce script installe `kube-prometheus-stack`, `loki-stack`, `jaeger-operator` et une instance Jaeger dans le namespace `observability`.*

## Configuration

Une fois la stack installée, appliquez les configurations de monitoring :

```bash
# Règles d'alerte (PrometheusRule)
kubectl apply -f alerts.yaml

# Scraping de l'application (ServiceMonitor)
kubectl apply -f servicemonitor.yaml
```

## Accès et Utilisation

### Grafana (Dashboards & Logs)

1.  **Récupérer le mot de passe admin** :
    ```bash
    kubectl get secret --namespace observability monitor-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
    ```

2.  **Accéder à l'interface** :
    ```bash
    kubectl port-forward --namespace observability svc/monitor-grafana 3000:80
    ```
    Ouvrez `http://localhost:3000` dans votre navigateur.

3.  **Dashboards** :
    *   Créez vos dashboards en utilisant les métriques Prometheus.
    *   Pour les logs, utilisez la datasource **Loki** dans l'onglet "Explore".

### Jaeger (Traces)

Pour accéder à l'interface de Jaeger :

```bash
kubectl port-forward --namespace observability svc/simplest-query 16686:16686
```
Ouvrez `http://localhost:16686`.

## Fichiers inclus

*   `install_stack.sh` : Script d'installation Helm.
*   `alerts.yaml` : Définition des alertes (Taux d'erreur, Redémarrages).
*   `servicemonitor.yaml` : Configuration pour scraper les métriques de l'API.
*   `alert_docs.md` : Documentation détaillée des alertes.
*   `dashboard_guide.md` : Guide pour la création des dashboards Grafana.
