# vim: filetype=hcl softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 commentstring=#%s expandtab
# code: language=terraform insertSpaces=true tabSize=2
# usage guide
# ╭──────────────────────────────────────────────────────────╮
# │ 1- create a builder for this file                        │
# ╰──────────────────────────────────────────────────────────╯
# docker buildx create --use --name "$(basename "$(git remote get-url origin)")" --driver docker-container
# ╭──────────────────────────────────────────────────────────╮
# │ 2-A run build without pushing to dockerhub               │
# ╰──────────────────────────────────────────────────────────╯
# LOCAL=true docker buildx bake --builder "$(basename "$(git remote get-url origin)")"
# ╭──────────────────────────────────────────────────────────╮
# │  2-B Run the build and push to docker hub                │
# ╰──────────────────────────────────────────────────────────╯
# docker buildx bake --builder "$(basename "$(git remote get-url origin)")"
# ╭──────────────────────────────────────────────────────────╮
# │                     cleanup builder                      │
# ╰──────────────────────────────────────────────────────────╯
# docker buildx ls | awk '$2 ~ /^docker(-container)*$/{print $1}' | xargs -r -I {} docker buildx rm {}
#
# variable
# ╭──────────────────────────────────────────────────────────╮
# │                    commmon variables                     │
# ╰──────────────────────────────────────────────────────────╯
# setting this variable to true will make stop the process from pushing the
# image to upstream docker registry.
#
# It is recommended to set this to true when working/experimenting with image
# builds; since by default images built with `bake` command do not show up when
# one runs `docker image ls`; `bake` command pushes the image to upstream
# registry and that can take a while depending on the image size; setting this
# variable to `true` makes sure that the built image is exported to local
# docker daemon so it would show up when one runs `docker image ls`.
variable "LOCAL" {default=false}
# ╭──────────────────────────────────────────────────────────╮
# │              multi-platform image variables              │
# ╰──────────────────────────────────────────────────────────╯
# Setting this variable to true will enable AMD64 architecture in targets
# that support multiplatform builds
#
# Realistically speaking , the only time one sets this variable to false is
# when experimenting with ARM64 builds and want the process to finish faster
# since building image for ARM64 and AMD64 can take a very long time, by
# disabling AMD64 builds, the process would end sooner.
variable "AMD64" {default=true}
# ────────────────────────────────────────────────────────────
# Setting this variable to true will enable AARCH64 architecture in targets
# that support multiplatform builds
variable "ARM64" {default=true}
# ╭──────────────────────────────────────────────────────────╮
# │                     Image base name                      │
# ╰──────────────────────────────────────────────────────────╯
# Base image name. It is recommended for this value to be the same as your Git
# repo name. You can set this value automatically through environment variable
# before running build command:
#
# export IMAGE_NAME="$(basename "$(git remote get-url origin)")";
variable "IMAGE_NAME" {default="nvim.d"}
# ────────────────────────────────────────────────────────────
# We do not push an image with `latest` tag. this is by design so that users of the Docker images
# always pin/use a specific tag/release.
#
# By default, the final basename of the image is going to be `${var.IMAGE_NAME}:<target-name>`
#
# We can use this variable to append a tag as suffix to the original target
# tag. This is exceptionally useful when 'docker buildx bake ...' command is
# running in CI/CD pipeline as in mostcases , when a tag is pushed and a runner
# starts, that tag is stored in am environment variable.
#
# for instance we can include release version by setting `TAG` environment variable which would make the final image basename to be
# '${var.IMAGE_NAME}:<target-name>-${var.TAG}'
variable "TAG" {default=""}
# ╭──────────────────────────────────────────────────────────╮
# │       full name of the main images in the registry       │
# ╰──────────────────────────────────────────────────────────╯
# Upstream image name is drived from `MAIN_REGISTRY_HOSTNAME` and
# `MAIN_REGISTRY_USERNAME`.
#
# As an example, If the base name of target image is 'foo:latest' then the
# complete name of the registry that Docker will push the image is going to be
# "${var.MAIN_REGISTRY_HOSTNAME}/${var.MAIN_REGISTRY_USERNAME}/foo:latest"
#
# for this project, the main images are stored in Dockerhub.
# ────────────────────────────────────────────────────────────
# hostname of the upstream registry that stores the main images.
#
# for this project, the main images are stored in dockerhub and
# dockerhub's automated build is setup.
variable "MAIN_REGISTRY_HOSTNAME" {default="docker.io"}
# ────────────────────────────────────────────────────────────
# username in upstream registry that stores the main images.
variable "MAIN_REGISTRY_USERNAME" {default="fjolsvin"}
# ╭──────────────────────────────────────────────────────────╮
# │        full name of cache images in the registry         │
# ╰──────────────────────────────────────────────────────────╯
# The Docker image and Docker image cache are pushed to sepratate registries.
# This is to prevent 'pollution' of the main image registry and keep things
# nice and tidy.
#
# As an example, If the base name of target image is 'foo:v1.0.0' then the
# complete name of the registry that Docker will push the image is going to be
# "${var.CACHE_REGISTRY_HOSTNAME}/${var.CACHE_REGISTRY_USERNAME}/foo-cachee:v1.0.0"
#
# ────────────────────────────────────────────────────────────
# hostname of the upstream registry that stores the build cache.
#
# As Dockerhub is used to build images, we can only leverage Buildx plugins
# capablities to push cache layers when `docker buildx bake` runs in a
# terminal; this means that Dockerhub builds cannot use this cache; this cache
# is used when a developer run `docker buildx bake ...` in their shell.
variable "CACHE_REGISTRY_HOSTNAME" {default="docker.io"}
# ────────────────────────────────────────────────────────────
# Username in upstream registry that stores cache images.
variable "CACHE_REGISTRY_USERNAME" {default="fjolsvin"}
#
# default build group
#
# The targets in `default` group are built when no specific build target is
# passed to buildx; i.e
#
# docker buildx bake --builder "$(basename "$(git remote get-url origin)")"
group "default" {
    targets = [
      "archlinux",
      "alpine",
    ]
}
# image build targets
#
# This target builds the ArchLinux the devcontainer docker image.
#
#
# Make sure that you have already authenticated against DockerHub
# Docker image registry before running a build job.
#
# Keep in mind that ArchLinux does not provide an official AARCH64 image so
# multi-platform builds are disabled.
# ─── SNIPPETS ───────────────────────────────────────────────────────────────────
# ❯ Build the without pushing to a registry (export to local docker daemon)
#
# LOCAL=true docker buildx bake --builder "$(basename "$(git remote get-url origin)")" "archlinux"
# ────────────────────────────────────────────────────────────
target "archlinux" {
    context="."
    dockerfile = ".devcontainer/archlinux.Dockerfile"
    tags = [
        equal("",TAG) ? "${MAIN_REGISTRY_HOSTNAME}/${MAIN_REGISTRY_USERNAME}/${IMAGE_NAME}:archlinux": "${MAIN_REGISTRY_HOSTNAME}/${MAIN_REGISTRY_USERNAME}/${IMAGE_NAME}:archlinux-${TAG}",
    ]
    cache-from   = [equal("",TAG) ? "type=registry,mode=max,ref=${CACHE_REGISTRY_HOSTNAME}/${CACHE_REGISTRY_USERNAME}/${IMAGE_NAME}-cache:archlinux": "type=registry,mode=max,ref=${CACHE_REGISTRY_HOSTNAME}/${CACHE_REGISTRY_USERNAME}/${IMAGE_NAME}-cache:archlinux-${TAG}"]
    cache-to   = [equal(LOCAL,true) ? "" : equal("",TAG) ? "type=registry,mode=max,ref=${CACHE_REGISTRY_HOSTNAME}/${CACHE_REGISTRY_USERNAME}/${IMAGE_NAME}-cache:archlinux": "type=registry,mode=max,ref=${CACHE_REGISTRY_HOSTNAME}/${CACHE_REGISTRY_USERNAME}/${IMAGE_NAME}-cache:archlinux-${TAG}"]
    output     = [equal(LOCAL,true) ? "type=docker" : "type=registry"]
}
# ────────────────────────────────────────────────────────────
# This target builds AlpineLinux based devcontainer docker image.
#
#
# Make sure that you have already authenticated against DockerHub
# Docker image registry before running a build job.
#
# Alpine linux image supports multiplatform builds.
# ─── SNIPPETS ───────────────────────────────────────────────────────────────────
# ❯ Build for both architectures without pushing to registry.
#
# LOCAL=true docker buildx bake --builder "$(basename "$(git remote get-url origin)")" "alpine"
#
# ❯ Build only for AMD64 architecture without pushing to registry
#
# LOCAL=true ARM64=false AMD64=true docker buildx bake --builder "$(basename "$(git remote get-url origin)")" "alpine"
#
# ❯ Build only for ARM64 architecture without pushing to registry
# ────────────────────────────────────────────────────────────
target "alpine" {
    context="."
    dockerfile = ".devcontainer/alpine.Dockerfile"
    tags = [
        equal("",TAG) ? "${MAIN_REGISTRY_HOSTNAME}/${MAIN_REGISTRY_USERNAME}/${IMAGE_NAME}:alpine": "${MAIN_REGISTRY_HOSTNAME}/${MAIN_REGISTRY_USERNAME}/${IMAGE_NAME}:alpine-${TAG}",
    ]
    platforms = [
        equal(AMD64,true) ?"linux/amd64":"",
        equal(ARM64,true) ?"linux/arm64":"",
    ]
    cache-from   = [equal("",TAG) ? "type=registry,mode=max,ref=${CACHE_REGISTRY_HOSTNAME}/${CACHE_REGISTRY_USERNAME}/${IMAGE_NAME}-cache/alpine": "type=registry,mode=max,ref=${CACHE_REGISTRY_HOSTNAME}/${CACHE_REGISTRY_USERNAME}/${IMAGE_NAME}-cache:alpine-${TAG}"]
    cache-to   = [equal(LOCAL,true) ? "" : equal("",TAG) ? "type=registry,mode=max,ref=${CACHE_REGISTRY_HOSTNAME}/${CACHE_REGISTRY_USERNAME}/${IMAGE_NAME}-cache/alpine": "type=registry,mode=max,ref=${CACHE_REGISTRY_HOSTNAME}/${CACHE_REGISTRY_USERNAME}/${IMAGE_NAME}-cache:alpine-${TAG}"]
    output     = [equal(LOCAL,true) ? "type=docker" : "type=registry"]
}
