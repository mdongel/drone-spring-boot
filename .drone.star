MICROSERVICE_NAME="integration-pay360-ms"
USERNAME_SECRET="docker_username"
PASSWORD_SECRET="docker_password"


def main(ctx):
  return springboot_microservice_pipeline(ctx, MICROSERVICE_NAME)

def springboot_microservice_pipeline(ctx, microservice_name):
  return {
    'kind': 'pipeline',
    'type': 'kubernetes',
    'name': 'default',
    'steps': [
    #  build(),
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
      'tags': "latest",
      'repo': 'mdongel/%s' % microservice_name,
      'username': {
        'from_secret': '%s' % USERNAME_SECRET,
      },
      'password': {
        'from_secret': '%s' % PASSWORD_SECRET,
      }
    },
  }

