from eom import rbac
from eom import auth
from deuce.transport.wsgi.app import app as deuce_app

from oslo.config import cfg
conf = cfg.CONF
conf(project='eom', args=[])
# Get the separated Redis Server for Auth
auth_redis_client = auth.get_auth_redis_client()
rbac_app = rbac.wrap(deuce_app)
app = auth.wrap(rbac_app, auth_redis_client)
