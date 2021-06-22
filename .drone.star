MICROSERVICE_NAME="integration-pay360-ms"

def main(ctx):
  return springboot_microservice_pipeline(ctx, MICROSERVICE_NAME)

def springboot_microservice_pipeline(ctx, microservice_name):
  return [
      pipeline(microservice_name),
  ]

def pipeline(microservice_name):
  return {
    'kind': 'pipeline',
    'name': 'default',
    'steps': [
      build(),
      publish(microservice_name),
    ],
  }

def build():
  return {
    'name': 'build',
    'image': 'adoptopenjdk/openjdk11',
    'commands': [
      './gradlew clean build',
    ],
  }

def publish(microservice_name):
  return {
    'name': 'publish',
    'image': 'plugins/docker',
    'settings': {
      'auto_tag': True,
      'auto_tag_suffix': 'linux-amd64',
      'repo': 'mdongel/' + microservice_name',
      'username': {
        'from_secret': 'docker_username',
      },
      'password': {
        'from_secret': 'docker_password',
      },
    },
  }