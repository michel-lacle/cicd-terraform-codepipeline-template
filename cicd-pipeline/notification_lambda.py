from urllib import request
import json, os


def send_message(event, context):

    # process all build events

    # if build is success full email QA
       # email to SNS logic
       # slack notification logic

    # if build fails email devlopers
       # email to SNS logic
       # slack notification logic


    # get url from environment variable
    url = os.environ['SLACK_URL']
    body = {"text": f"```${event}```"}

    jsondata = json.dumps(body);
    jsondatabytes = jsondata.encode('utf-8')

    req = request.Request(url)
    req.add_header('Content-type', 'application/json');
    resp = request.urlopen(req, jsondatabytes)

    print(resp)


#send_message("arg1", "arg2")
