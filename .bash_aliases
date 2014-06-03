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

#pretty print and syntax highlight xml
curl-xml(){
	curl ${1} -H'Accept: application/xml' | xmllint --format - | pygmentize -l xml
}

#pretty print and syntax highlight json
curl-json() {
    curl ${1} -H'Accept: application/json' | json_pp | pygmentize -l json
}
