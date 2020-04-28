from urllib import request
import json, os, boto3


def send_to_slack(message):
    url = os.environ['SLACK_URL']
    body = {"text": message}
    bytes = json.dumps(body).encode('utf-8')

    req = request.Request(url)
    req.add_header('Content-type', 'application/json');
    resp = request.urlopen(req, bytes)


def send_to_email(message, subject):
    arn = os.environ['EMAIL_TOPIC_ARN']

    client = boto3.client('sns')

    response = client.publish(
        TopicArn=arn,
        Message=message,
        Subject=subject
    )


# entry point of lambda
def send_message(event, context):
    debug = os.environ['DEBUG']

    if debug == "true":
        send_to_slack(f"```{event}```")

    message = os.environ['MESSAGE']
    subject = os.environ['SUBJECT']

    send_to_slack(message)

    send_to_email(message, subject)
