import json
import os
import urllib.request
from functools import lru_cache

import boto3

ssm = boto3.client("ssm", region_name="eu-west-2")


@lru_cache(maxsize=1)
def get_api_key():
    param_name = os.environ.get("API_KEY_PATH", "/weather-app/stage/api-key")
    response = ssm.get_parameter(Name=param_name, WithDecryption=True)
    return response["Parameter"]["Value"]


def get_cors_origin():
    return os.environ.get("CORS_ORIGIN", "https://www.yashjagani.com")


def lambda_handler(event, context):
    try:
        api_key = get_api_key()

        body = json.loads(event.get("body", "{}"))
        city = body.get("city", "London")

        url = f"https://api.openweathermap.org/data/2.5/forecast?q={city}&appid={api_key}&units=metric&cnt=24"
        with urllib.request.urlopen(url, timeout=5) as response:
            data = json.loads(response.read().decode())

        forecasts = []
        seen_dates = []
        for item in data["list"]:
            date = item["dt_txt"].split(" ")[0]
            if date not in seen_dates:
                seen_dates.append(date)
                forecasts.append(
                    {
                        "date": date,
                        "temp": round(item["main"]["temp"]),
                        "feels_like": round(item["main"]["feels_like"]),
                        "humidity": item["main"]["humidity"],
                        "description": item["weather"][0]["description"],
                        "icon": item["weather"][0]["icon"],
                    }
                )
            if len(forecasts) == 3:
                break

        return {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Origin": get_cors_origin(),
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "POST,OPTIONS",
            },
            "body": json.dumps(
                {
                    "city": data["city"]["name"],
                    "country": data["city"]["country"],
                    "forecasts": forecasts,
                }
            ),
        }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            "statusCode": 500,
            "headers": {"Access-Control-Allow-Origin": get_cors_origin()},
            "body": json.dumps({"error": str(e)}),
        }
