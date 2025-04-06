# 0.5.12 (Apr 06, 2025)
* Set load balancer to internal when not publicly accessible.

# 0.5.11 (Apr 06, 2025)
* Emit `private_urls` instead of `public_urls` from outputs when not publicly accessible.

# 0.5.10 (Apr 06, 2025)
* Added support for private load balancer via `var.is_publicly_accessible`.

# 0.5.8 (Apr 03, 2025)
* Added support for optional IP whitelist (`var.ip_whitelist`).

# 0.5.7 (Mar 31, 2025)
* Use SSL certificate from connected subdomain if it created one.

# 0.5.6 (Aug 27, 2024)
* Added load balancer name to metrics chart names.

# 0.5.5 (Apr 29, 2024)
* Added `idle_timeout` variable.

# 0.5.4 (Apr 03, 2024)
* Added vars for `desync_mitigation_mode` and `drop_invalid_header_fields`.

# 0.5.3 (Mar 19, 2024)
* Upgrade terraform providers and locked with `.terraform.lock.hcl`.

# 0.5.2 (Feb 06, 2024)
* Added initial metrics.

# 0.5.1 (Nov 30, 2023)
* Added support for sticky sessions.

# 0.5.0 (Aug 07, 2023)
* Create `README.md` with guidance and documentation.
