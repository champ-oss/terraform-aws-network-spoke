import urllib3
import os

URL = os.getenv('URL', 'localhost')


def handler(_, __) -> None:
    print(f'connecting to {URL}')
    http = urllib3.PoolManager()
    resp = http.request('GET', URL)
    print(f'status: {resp.status}')
    print(f'data: {str(resp.data, "utf-8")}')


if __name__ == '__main__':
    handler(None, None)
