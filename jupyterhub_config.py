import os
from jupyter_client.localinterfaces import public_ips

c.JupyterHub.spawner_class = 'dockerspawner.DockerSpawner'
c.DockerSpawner.remove_containers = True
c.DockerSpawner.remove = True
c.Spawner.environment = {'GRANT_SUDO': 'yes'}
c.JupyterHub.authenticator_class = 'dummyauthenticator.DummyAuthenticator'
c.DummyAuthenticator.password = "b5a738faf73c0738b4a2e21b1630fb6d"

c.DockerSpawner.image = 'snamburi3/singleuser_omero_for_python'
c.JupyterHub.hub_ip = public_ips()[0]
c.Spawner.environment = { 'JUPYTER_ENABLE_LAB': 'yes' }
c.Spawner.default_url = '/lab'
c.DockerSpawner.default_url = '/lab'
c.Spawner.debug = True
c.Authenticator.delete_invalid_users = True

notebook_dir = '/home/jovyan/'
c.DockerSpawner.notebook_dir = notebook_dir
c.DockerSpawner.volumes = { 'jupyterhub-user-{username}': notebook_dir }
c.DockerSpawner.host_ip = '0.0.0.0'
c.JupyterHub.proxy_cmd = ['configurable-http-proxy']

c.Spawner.cpu_guarantee = 2
c.Spawner.cpu_limit = 2
c.Spawner.mem_guarantee = '2G'
c.Spawner.mem_limit = '2G' 

c.Spawner.http_timeout = 60
c.Spawner.start_timeout = 60

c.Authenticator.admin_users = admin = set()

join = os.path.join
here = os.path.dirname(__file__)
with open(join(here, '/home/jupyter/userlist')) as f:
    for line in f:
        if not line:
            continue
        parts = line.split()
        name = parts[0]
        if len(parts) > 1 and parts[1] == 'admin':
            admin.add(name)

