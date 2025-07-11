resource "aws_s3_bucket" "mlflow_artifacts" {
    bucket = "mlflow-artifacts-${random_id.suffix.hex}"
    force_destroy = true
}

resource "random_id" "suffix" {
    byte_length = 4
}