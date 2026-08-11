# API Gateway
Ingress for both ops consoles. OIDC authn, per-principal rate limits, WAF in front
(managed rules + bot control), request signing to the control plane. Deployed via
`infrastructure/terraform/modules/networking` + ALB/WAF resources.
