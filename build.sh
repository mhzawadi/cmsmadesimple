#!/bin/sh

. ~/.docker_build

# generate the image tag
#export TARGET_IMAGE_TAG=$(if [ "$TRAVIS_BRANCH" = "master" ]; then if [ "$TAG_SUFFIX" = "" ]; then echo "latest"; else echo "$TAG_SUFFIX"; fi; else if [ "$TAG_SUFFIX" = "" ]; then echo "$TRAVIS_BRANCH"; else echo "$TRAVIS_BRANCH-$TAG_SUFFIX"; fi; fi)

# pull the existing image from the registry, if it exists, to use as a build cache
docker pull $SOURCE_IMAGE:$SOURCE_IMAGE_TAG && export IMAGE_CACHE="--cache-from $SOURCE_IMAGE:$SOURCE_IMAGE_TAG" || export IMAGE_CACHE=""

# build the image, login and push
docker build -f "$DOCKERFILE" $IMAGE_CACHE --build-arg MH_ARCH=$SOURCE_IMAGE --build-arg MH_TAG=$SOURCE_IMAGE_TAG -t "$TARGET_IMAGE:$TARGET_IMAGE_TAG" .
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker push $TARGET_IMAGE:$TARGET_IMAGE_TAG

# push alternate tags
if [ -z "$ALT_SUFFIX" ]; then
  echo "No alternate tags set for this build.";
else
  echo "Tagging with alternate tag '$ALT_SUFFIX'";
  export ALT_IMAGE_TAG=$(if [ "$TRAVIS_BRANCH" = "master" ]; then if [ "$ALT_SUFFIX" = "" ]; then echo "error"; else echo "$ALT_SUFFIX"; fi; else if [ "$ALT_SUFFIX" = "" ]; then echo "$TRAVIS_BRANCH"; else echo "$TRAVIS_BRANCH-$ALT_SUFFIX"; fi; fi);
  docker tag $TARGET_IMAGE:$TARGET_IMAGE_TAG $TARGET_IMAGE:$ALT_IMAGE_TAG;
  docker push $TARGET_IMAGE:$ALT_IMAGE_TAG;
fi