resource "aws_s3_bucket" "codepipeline-s3-bucket" {
  bucket = "codepipeline-${var.application-name}"
  acl = "private"
}

resource "aws_iam_role" "codepipeline-iam-role" {
  name = "codepipeline-${var.application-name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline-iam-role-policy" {
  name = "codepipeline-${var.application-name}"
  role = aws_iam_role.codepipeline-iam-role.id

  policy = file("codepipeline_iam_policy.json")
}

resource "aws_codepipeline" "codepipeline" {
  name = var.application-name
  role_arn = aws_iam_role.codepipeline-iam-role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline-s3-bucket.bucket
    type = "S3"
  }

  stage {
    name = "Source"

    action {
      name = "Source"
      category = "Source"
      owner = "AWS"
      provider = "CodeCommit"
      version = "1"
      output_artifacts = [
        "SourceArtifact"]

      configuration = {
        RepositoryName = var.repository-name
        BranchName = var.branch
        PollForSourceChanges = true
      }

      namespace = "SourceVariables"
    }
  }

  stage {
    name = "Build"

    action {
      name = "Build"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      input_artifacts = [
        "SourceArtifact"]
      output_artifacts = [
        "BuildArtifact"]
      version = "1"

      configuration = {
        ProjectName = aws_codebuild_project.codebuild-project.name
      }

      namespace = "BuildVariables"
    }
  }

  stage {
    name = "Deploy"

    action {
      name = "CopyToS3"
      category = "Deploy"
      owner = "AWS"
      provider = "S3"
      input_artifacts = [
        "BuildArtifact"]
      version = "1"

      configuration = {
        BucketName = aws_s3_bucket.cicd-artifact-s3-bucket.bucket
        Extract = false

        ObjectKey = "#{SourceVariables.BranchName}/${var.application-name}-{datetime}--#{SourceVariables.CommitId}.zip"
      }
    }
  }
}

