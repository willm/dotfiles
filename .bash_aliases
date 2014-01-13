#git aliases
alias ga='git add -A; git status;'
alias gs='git status'
gcp(){
	git commit -m "$1";
	git push origin master;
}

#create a directory and cd into it
mkdircd(){
	mkdir $1;
	cd $1;
}

ddex(){
	cd ~/Documents/python/DDEXUI
}
alias cls='clear'
