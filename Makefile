test:
	# Checking for syntax errors
	set -e; for SCRIPT in autoconfig/* framework.sh grml2hd/*/* grml2usb/* grml-debootstrap/* lvm/*; \
	do \
	        zsh -n $$SCRIPT; \
	done
