terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "4.2.0"
    }
  }
}

provider "cloudflare" {
  email  = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

resource "cloudflare_zone" "example" {
  account_id = var.cloudflare_account_id
  zone = "itca.pp.ua"
  type = "full"
  jump_start = true
}

resource "cloudflare_record" "example_a" {
  zone_id = cloudflare_zone.example.id
  name    = "@"
  value   = "19.18.55.1"
  type    = "A"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "example_cname" {
  zone_id = cloudflare_zone.example.id
  name    = "www"
  value   = "@"
  type    = "CNAME"
  ttl     = 1
  proxied = true

}

resource "cloudflare_zone_settings_override" "example" {
  zone_id = cloudflare_zone.example.id
  settings {
    always_use_https = "on"
    automatic_https_rewrites = "on"
    ssl = "flexible"
  }
}