resource "aws_s3_bucket" "template-codepipeline" {
  bucket = "template-codepipeline"
  acl = "private"
}

resource "aws_iam_role" "template-codepipeline-role" {
  name = "template-codepipeline-role"

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

resource "aws_iam_role_policy" "template-codepipeline_policy" {
  name = "template-codepipeline-policy"
  role = aws_iam_role.template-codepipeline-role.id

  policy = file("aws_codepipeline_iam_policy.json")
}

resource "aws_codepipeline" "codepipeline" {
  name = "template-cicd-pipeline"
  role_arn = aws_iam_role.template-codepipeline-role.arn

  artifact_store {
    location = aws_s3_bucket.template-codepipeline.bucket
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
        RepositoryName = aws_codecommit_repository.terraform-codepipeline-template.repository_name
        BranchName = "master"
        PollForSourceChanges = true
      }
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
        ProjectName = aws_codebuild_project.talos-build-project.name
      }
    }
  }
/*
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
        BucketName = "progress-rail"
        Extract = false

        # TODO manually configure ObjectKey in AWS console to use
        # #{SourceVariables.BranchName}/Talos-{datetime}--#{SourceVariables.CommitId}.zip
        #ObjectKey = "#{SourceVariables.BranchName}/Talos-{datetime}--#{SourceVariables.CommitId}.zip"
        ObjectKey = "Talos-DONOTUSE.zip"
        #
      }
    }
    */
  }
}

