PRIV :=

image_name := ubuntu:20.04
container_name := ctf-env-$(shell whoami)

args := -p 2333:2333 -p 6666:6666

ifneq ($(PRIV),)
  args += --privileged
endif

build:
	docker build -t $(image_name) .

start:
	docker run -dt --name $(container_name) $(args) $(image_name)

run:
	docker exec -it $(container_name) bash
