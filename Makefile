FIRMWAREDIR = /usr/lib/firmware/updates
NUM_JOBS := $(or $(patsubst -j%,%,$(filter -j%,$(MAKEFLAGS))),\
		 1)

all:

dist:
	@mkdir -p release dist
	./copy-firmware.sh release
	@TARGET=linux-firmware_`git describe`.tar.gz; \
	cd release && tar -czf ../dist/$${TARGET} *; \
	echo "Created dist/$${TARGET}"
	@rm -rf release

install:
	install -d $(DESTDIR)$(FIRMWAREDIR)
	./copy-firmware.sh -j$(NUM_JOBS) $(DESTDIR)$(FIRMWAREDIR)

install-xz:
	install -d $(DESTDIR)$(FIRMWAREDIR)
	./copy-firmware.sh -j$(NUM_JOBS) --xz $(DESTDIR)$(FIRMWAREDIR)

install-zst:
	install -d $(DESTDIR)$(FIRMWAREDIR)
	./copy-firmware.sh -j$(NUM_JOBS) --zstd $(DESTDIR)$(FIRMWAREDIR)

clean:
	rm -rf release dist
