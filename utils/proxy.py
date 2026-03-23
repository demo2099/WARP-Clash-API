"""

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, see <https://www.gnu.org/licenses>.

"""
import requests

from config import PROXY_POOL_URL


def getProxy():
    """
    Get proxy from proxy pool
    :return: proxy got from proxy pool
    """
    if not PROXY_POOL_URL:
        return {}

    try:
        ret = requests.get(PROXY_POOL_URL, timeout=15).json()
        raw_proxy = ret.get('proxy')
        if not raw_proxy:
            return {}

        proxy_url = raw_proxy if "://" in raw_proxy else f"http://{raw_proxy}"
        # Keep both keys for requests compatibility.
        return {
            "http": proxy_url,
            "https": proxy_url
        }
    except Exception:
        return {}
