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
import os

DELAY_THRESHOLD = int(os.environ.get('DELAY_THRESHOLD')) if os.environ.get('DELAY_THRESHOLD') else 500
DO_GET_WARP_DATA = os.environ.get('DO_GET_WARP_DATA', 'true').lower() == 'true'
GET_WARP_DATA_INTERVAL = int(os.environ.get('GET_WARP_DATA_INTERVAL', 18))
HOST = os.environ.get('HOST') or '0.0.0.0'
LOSS_THRESHOLD = int(os.environ.get('LOSS_THRESHOLD')) if os.environ.get('LOSS_THRESHOLD') else 10
PORT = int(os.environ.get('PORT')) if os.environ.get('PORT') else 3000
PROXY_POOL_URL = os.environ.get('PROXY_POOL_URL', 'https://getproxy.bzpl.tech/get/')
USE_PROXY_POOL = os.environ.get('USE_PROXY_POOL', 'true').lower() == 'true'
ALLOW_DIRECT_REGISTER_FALLBACK = os.environ.get('ALLOW_DIRECT_REGISTER_FALLBACK', 'false').lower() == 'true'
PUBLIC_URL = os.environ.get('PUBLIC_URL') or None
RANDOM_COUNT = int(os.environ.get('RANDOM_COUNT')) if os.environ.get('RANDOM_COUNT') else 10
REOPTIMIZE_INTERVAL = int(os.environ.get('REOPTIMIZE_INTERVAL', -1))
REQUEST_RATE_LIMIT = int(os.environ.get('REQUEST_RATE_LIMIT')) if os.environ.get('REQUEST_RATE_LIMIT') else 0
SECRET_KEY = os.environ.get('SECRET_KEY') or None
SHARE_SUBSCRIPTION = os.environ.get('SHARE_SUBSCRIPTION', 'false').lower() == 'true'
CF_API_URL = os.environ.get('CF_API_URL', 'https://api.cloudflareclient.com')
CF_API_VERSION = os.environ.get('CF_API_VERSION', 'v0i2308311933')
CF_CLIENT_VERSION = os.environ.get('CF_CLIENT_VERSION', 'i-6.23-2308311933.1')
CF_USER_AGENT = os.environ.get('CF_USER_AGENT', '1.1.1.1/6.23')
REQUEST_TIMEOUT = int(os.environ.get('REQUEST_TIMEOUT', 20))
REGISTER_MAX_RETRIES = int(os.environ.get('REGISTER_MAX_RETRIES', 2))
REGISTER_RETRY_SLEEP = float(os.environ.get('REGISTER_RETRY_SLEEP', 1.5))
IGNORE_ENV_PROXY = os.environ.get('IGNORE_ENV_PROXY', 'true').lower() == 'true'
