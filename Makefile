src_dir := .src
backup_dir := .bak
objects := .aliases .gitconfig .tmux.conf .vimrc .zshrc

.PHONY: install
install: $(objects)

$(backup_dir):
	mkdir -p $(backup_dir)

$(backup_dir)/.git: | $(backup_dir)
	cd $(backup_dir) && git init

.SECONDEXPANSION:
$(objects): $(src_dir)/$$@ | $(backup_dir)/.git
	test ! -f $@ || (cp -a $@ $(backup_dir) && cd $(backup_dir) && git add $@ && git commit -m 'automatic backup $@' $@)
	cp -a $^ $@
