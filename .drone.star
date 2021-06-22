MICROSERVICE_NAME="integration-pay360-ms"

def main(ctx):
  return springboot_microservice_pipeline(ctx, MICROSERVICE_NAME)

def springboot_microservice_pipeline(ctx, microservice_name):
  return {
    'kind': 'pipeline',
    'name': 'default',
    'steps': [
      build(),
      publish_to_docker_registry(microservice_name),
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

def publish_to_docker_registry(microservice_name):
  return {
    'name': 'publish',
    'image': 'plugins/docker',
    'settings': {
      'registry': 'hub.docker.com',
      'auto_tag': True,
      'auto_tag_suffix': 'linux-amd64',
      'repo': 'hub.docker.com/mdongel/%s' % microservice_name,
      'username': {
        'from_secret': 'docker_username',
      },
      'password': {
        'from_secret': 'docker_password',
      },
    },
  }