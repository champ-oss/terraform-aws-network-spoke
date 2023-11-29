import urllib3
import os

URL = os.getenv('URL', 'localhost')
SEARCH_DATA = os.getenv('SEARCH_DATA')


def handler(_, __) -> None:
    print(f'connecting to {URL}')
    http = urllib3.PoolManager()
    resp = http.request('GET', URL)
    print(f'status: {resp.status}')
    print(f'data: {str(resp.data, "utf-8")}')

    if not SEARCH_DATA:
        return
    for entry in SEARCH_DATA.split(','):
        if entry in str(resp.data, "utf-8"):
            print(f'search data found: {entry}')


if __name__ == '__main__':
    handler(None, None)
