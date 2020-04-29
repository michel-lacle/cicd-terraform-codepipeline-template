{
  "source": [
    "aws.codepipeline"
  ],
  "detail-type": [
    "CodePipeline Pipeline Execution State Change"
  ],
  "detail": {
    "pipeline": [
        "${codepipeline-name}"
    ],
    "state" : ["${state}"]
  }
}