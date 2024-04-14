provider "aws" {
  region = "us-east-1"
}

provider "vault" {
  address = "<vaultIP address>:8200"    #server IP address here
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "<>"  #enter role ID here
      secret_id = "<>"   #enter secret ID here
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "secret" // change it according to your mount
  name  = "test-secret" // change it according to your secret
}

resource "aws_instance" "my_instance" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

  tags = {
    Name = "test"
    Secret = data.vault_kv_secret_v2.example.data["foo"]
  }
}
