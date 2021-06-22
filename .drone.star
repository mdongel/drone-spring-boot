def main(ctx):
  return [
      pipeline(),
  ]

def pipeline():
  return {
    'kind': 'pipeline',
    'name': 'default',
    'steps': [
      build(),
      publish(),
    ],
  }

def build():
  return {
    'name': 'build',
    'image': 'adoptopenjdk/openjdk11',
    'commands': [
      './gradlewgg clean build',
    ],
  }

def publish():
  return {
    'name': 'publish',
    'image': 'plugins/docker',
    'settings': {
      'auto_tag': True,
      'auto_tag_suffix': 'linux-amd64',
      'repo': 'mdongel/myrepo',
      'username': {
        'from_secret': 'docker_username',
      },
      'password': {
        'from_secret': 'docker_password',
      },
    },
  }