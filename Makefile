all: box.stl

DOCKER = docker
OPENSCAD = openscad
INKSCAPE = inkscape
PSTOEDIT = pstoedit

ifeq ($(USE_DOCKER),Yes)
	STL_BUILD_CMD = $(DOCKER) run --rm --volume $$(pwd):/build boxbuilder $(OPENSCAD)
	EPS_BUILD_CMD = $(DOCKER) run --rm --volume $$(pwd):/build boxbuilder $(INKSCAPE)
	DXF_BUILD_CMD = $(DOCKER) run --rm --volume $$(pwd):/build boxbuilder $(PSTOEDIT)
	DOCKER_DEP = .docker/build
else
	STL_BUILD_CMD = $(OPENSCAD)
	EPS_BUILD_CMD = $(INKSCAPE)
	DXF_BUILD_CMD = $(PSTOEDIT)
	DOCKER_DEP =
endif

$(DOCKER_DEP): Dockerfile
	$(DOCKER) build --tag boxbuilder .
	mkdir -p .docker
	touch .docker/build

img.eps: img.svg $(DOCKER_DEP)
	$(EPS_BUILD_CMD) -E $@ $<

img.dxf: img.eps $(DOCKER_DEP)
	$(DXF_BUILD_CMD) -dt -f "dxf: -polyaslines -mm" $< $@

box.stl: box.scad img.dxf $(DOCKER_DEP)
	$(STL_BUILD_CMD) -o $@ $<
