output "codepipeline-name" {
  value = aws_codepipeline.codepipeline.name
}

output "cicd-artifact-bucket-name" {
  value = aws_s3_bucket.cicd-artifact-s3-bucket.bucket
}