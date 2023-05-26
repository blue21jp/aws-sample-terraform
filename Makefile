#
# Makefile
#

# stacks_template/Mkefileを stacks_xxx/Makefileにコピーする
copy_makefile:
	@for target in $(shell find . -maxdepth 1 -type d -name "stacks_*" | tr -d './' | grep -v 'stacks_template' ); do \
		cp ./stacks_template/Makefile $$target/; \
	done

# stacks_base/00_checkを stacks_xxx/にコピーする
copy_check:
	@for target in $(shell find . -maxdepth 1 -type d -name "stacks_*" | tr -d './' | egrep -v 'stacks_template' ); do \
		rm -fr $$target/00_check > /dev/null 2>&1; \
		cp -r ./stacks_template/00_check $$target/; \
	done
