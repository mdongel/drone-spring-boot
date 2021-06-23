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
    "environment": {
        "ACR_USERNAME": {
            "from_secret": "azenv_central_registry_username"
        },
        "ACR_PASSWORD": {
            "from_secret": "azenv_central_registry_password"
        },
            "ACR_LOGINSERVER": "bankifilabsgeneralregistry.azurecr.io"
    },
    'settings': {
      'registry': 'index.docker.io',
      'auto_tag': True,
      'auto_tag_suffix': 'linux-amd64',
      'repo': 'docker.io/mdongel/%s' % microservice_name,
      'username': '$ACR_USERNAME',
      'password': {
        'from_secret': 'docker_password',
      },
    },
  }