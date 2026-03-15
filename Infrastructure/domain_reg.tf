resource "aws_route53domains_domain" "camdev_domain" {
  domain_name       = "camdevcloud.dev"
  duration_in_years = "1"

  admin_contact {
    address_line_1 = "28 Vertex Lane"
    city           = "Adelaide"
    contact_type   = "PERSON"
    country_code   = "AU"
    email          = "campage1999@gmail.com"
    first_name     = "Cameron"
    last_name      = "Page"
    phone_number   = "+61450316169"
    state          = "SA"
    zip_code       = "5042"
  }

  registrant_contact {
    address_line_1 = "28 Vertex Lane"
    city           = "Adelaide"
    contact_type   = "PERSON"
    country_code   = "AU"
    email          = "campage1999@gmail.com"
    first_name     = "Cameron"
    last_name      = "Page"
    phone_number   = "+61450316169"
    state          = "SA"
    zip_code       = "5042"
  }

  tech_contact {
    address_line_1 = "28 Vertex Lane"
    city           = "Adelaide"
    contact_type   = "PERSON"
    country_code   = "AU"
    email          = "campage1999@gmail.com"
    first_name     = "Cameron"
    last_name      = "Page"
    phone_number   = "+61450316169"
    state          = "SA"
    zip_code       = "5042" 
  }

  tags = {
    Name        = "Cam Cloud Dev Resume Website"
    Environment = "Production"
  }
}
