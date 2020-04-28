from urllib import request
import json, os


def send_to_slack(message):
    url = os.environ['SLACK_URL']
    body = {"text": f"```${message}```"}
    bytes = json.dumps(body).encode('utf-8')

    req = request.Request(url)
    req.add_header('Content-type', 'application/json');
    resp = request.urlopen(req, bytes)

    print(resp)


# entry point of lambda
def send_message(event, context):
    debug = os.environ['DEBUG']

    if debug == 1:
        send_to_slack(event)

    # now send message to slack
    bucket_name = os.environ['BUILD_ARTIFACT_BUCKET']
    download_url = f"https://s3.console.aws.amazon.com/s3/buckets/${bucket_name}/?region=us-east-1"

    message = f"Build Succeeded, please download latest artifact here: ${download_url}"

    # send notificaton to users that build is complete
    send_to_slack(message)
