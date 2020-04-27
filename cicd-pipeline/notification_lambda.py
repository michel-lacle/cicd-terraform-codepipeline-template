from urllib import request
import json, os


def send_message(event, context):
    # get url from environment variable
    url = os.environ['SLACK_URL']
    body = {"text": f"```${event}```"}

    jsondata = json.dumps(body);
    jsondatabytes = jsondata.encode('utf-8')

    req = request.Request(url)
    req.add_header('Content-type', 'application/json');
    resp = request.urlopen(req, jsondatabytes)

    print(resp)