#create random suffix
resource "random_string" "suffix" {
    length  = 8
    special = false
}