
# Argo CD Blue-Green Deployment Walkthrough

## Repo Structure

```
color-webapp-gitops/
├── initial-deployment.yaml
├── active-service.yaml
├── service.yaml
├── manual-drift.yaml
├── reverted-deployment.yaml
├── rollout.yaml
├── preview-service.yaml
├── analysis-template.yaml
└── README.md
```

## Walkthrough Steps

1. **Start with Argo CD sync** using `initial-deployment.yaml` and `active-service.yaml`.
2. **Simulate drift** by applying `manual-drift.yaml` manually via `kubectl apply -f`.
3. Argo CD will show **OutOfSync**.
4. **Revert drift** using `reverted-deployment.yaml`.
5. Move `rollout.yaml` from archive to root and apply it.
6. Argo CD syncs the rollout and preview service.
7. Use port-forwarding:
   ```bash
   kubectl port-forward svc/color-web-active 8082:80
   kubectl port-forward svc/color-web-preview 8083:82
   ```
8. Open two browser tabs:
   - `localhost:8082` → blue (live)
   - `localhost:8083` → yellow (preview)
9. Validate preview using `analysis-template.yaml`.
10. Promote green using:
    ```bash
    kubectl argo rollouts promote color-web
    ```
