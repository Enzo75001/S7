# Guide Dashboard Grafana

Ce guide explique comment créer le dashboard requis pour le module S7.

## Accès à Grafana

1.  Récupérer le mot de passe admin :
    ```bash
    kubectl get secret --namespace observability monitor-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
    ```
2.  Port-forward :
    ```bash
    kubectl port-forward --namespace observability svc/monitor-grafana 3000:80
    ```
3.  Accéder à `http://localhost:3000` (User: `admin`).

## Création du Dashboard

Créer un nouveau dashboard et ajouter les panels suivants :

### 1. Latence (Latency)
*   **Visualisation** : Time Series
*   **Query (PromQL)** :
    ```promql
    histogram_quantile(0.95, sum(rate(http_request_duration_seconds_bucket[5m])) by (le))
    ```
    *(Note : Adapter la métrique selon ce qui est exposé par l'application)*

### 2. Taux d'Erreurs (Error Rate)
*   **Visualisation** : Time Series
*   **Query (PromQL)** :
    ```promql
    sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m]))
    ```

### 3. Saturation (CPU/Memory)
*   **Visualisation** : Time Series
*   **Query (PromQL)** :
    ```promql
    sum(rate(container_cpu_usage_seconds_total{namespace="workshop", container!=""}[5m])) by (pod)
    ```

## Logs (Loki)
*   Ajouter un panel "Logs".
*   Sélectionner la datasource "Loki".
*   Query : `{namespace="workshop"}`

## Traces (Jaeger)
*   Configurer la datasource Jaeger si nécessaire (URL: `http://simplest-query.observability:16686`).
