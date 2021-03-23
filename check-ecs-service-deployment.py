import boto3
import json
import logging
import sys
import time
import os
import re
from botocore.exceptions import ClientError

# A Python3 script to check if the image built in prior task in the pipeline is deployed.
# Get tasks of the specify service from list_tasks
#

# Initialize logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)
handler = logging.StreamHandler(sys.stdout)
logger.addHandler(handler)

# Initialize ECS
ecs = boto3.client('ecs')


def get_service_primary_task_definition(cluster_name, service_name):
    # Get the task definition ARN from the PRIMARY deployment of the service.
    try:
        logger.debug('Getting task definition of {} in {}.'.format(
            service_name, cluster_name))
        describe_services_resp = ecs.describe_services(
            cluster=cluster_name,
            services=[
                service_name
            ]
        )
    except ClientError as e:
        logger.error(e.response['Error']['Message'])
        sys.exit(1)

    for service in describe_services_resp['services']:
        for deployment in service['deployments']:
            if deployment['status'] == 'PRIMARY':
                logger.debug('Task definition in PRIMARY deployment: {}'.format(
                    deployment['taskDefinition']))
                return deployment['taskDefinition']
            else:
                logger.error(
                    'Task definition not found in the PRIMARY deployment.')
                return None


def get_container_images(task_definition):
    # Get a list of container images in the task definition.
    describe_task_definition_resp = ecs.describe_task_definition(
        taskDefinition=task_definition)

    logger.debug('Found {} container images in task definition {}.'.format(len(
        describe_task_definition_resp['taskDefinition']['containerDefinitions']), task_definition))
    container_images = []
    for container_definition in describe_task_definition_resp['taskDefinition']['containerDefinitions']:
        container_images.append(container_definition['image'])
    return container_images


def check_image_in_deployment(cluster_name, service_name, image):
    # Check if the image is in the list.
    running_task_definition = get_service_primary_task_definition(
        cluster_name, service_name)
    if running_task_definition != None:
        running_container_images = get_container_images(
            running_task_definition)
        if image in running_container_images:
            return True
        else:
            return False
    else:
        return False


def check_service_in_cluster(cluster_name, service_name):
    # Check if the the service is in the specified ECS cluster.
    services_in_cluster = []
    paginator = ecs.get_paginator('list_services')
    try:
        page_iterator = paginator.paginate(cluster=cluster_name)
        for page in page_iterator:
            for service in page['serviceArns']:
                services_in_cluster.append(service)
    except ClientError as e:
        logger.error(e.response['Error']['Message'])
        sys.exit(1)

    logger.debug('Found {} services.'.format(len(services_in_cluster)))
    regex_pattern = re.compile(service_name)
    filtered_list = list(filter(regex_pattern.search, services_in_cluster))
    logger.debug('Match: {}'.format(filtered_list))
    if filtered_list:
        return True
    else:
        return False


# The variables we need.
i = 1
ecs_cluster = os.environ['CLUSTER']
ecs_service = os.environ['SERVICE']
# The container image URL should be like this $REPOSITORY_URL/$CI_COMMIT_REF_NAME:$CI_PIPELINE_ID
deployed_image = os.environ['IMAGE']

if check_service_in_cluster(ecs_cluster, ecs_service):
    while i <= 3:
        if check_image_in_deployment(ecs_cluster, ecs_service, deployed_image):
            logger.info('The image {} is deployed.'.format(deployed_image))
            image_is_deployed = True
            break
        else:
            if i < 3:
                logger.warning('Image not found. Retrying...')
                time.sleep(30)
            else:
                logger.error('Image not found. Please try again later.')
                image_is_deployed = False
            i += 1
else:
    logger.error('Service not found.')
    sys.exit(1)


if image_is_deployed:
    sys.exit(0)
else:
    sys.exit(1)
