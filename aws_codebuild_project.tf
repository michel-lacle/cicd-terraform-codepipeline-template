resource "aws_iam_role" "codebuild-role" {
  name = "codebuild-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild-role-policy" {
  role = aws_iam_role.codebuild-role.name

  policy = file("aws_codebuild_project_iam_policy.json")
}

resource "aws_codebuild_project" "talos-build-project" {
  name = "template-build"
  description = "build the template app"

  # in minutes
  build_timeout = "10"
  service_role = aws_iam_role.codebuild-role.arn

  source {
    type = "CODEPIPELINE"
  }

  # what do we do with other branches?
  source_version = "master"

  // TODO we may need to set this to CODEPIPELINE
  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/standard:4.0"
    type = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    # enable us to run the docker deamon inside a docker container
    privileged_mode = true
  }

  tags = {
    Environment = "Private"
  }
}