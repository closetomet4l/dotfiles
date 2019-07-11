# ------------------------------------
# Environment Variables
# ------------------------------------

set -g -x GOPATH ~/go
set -g -x PATH $PATH /usr/local/go/bin eval $GOPATH/bin ~/Library/Python/2.7/bin

# ------------------------------------
# Docker functions
# ------------------------------------

# Get process included stop container
function dpa
    docker ps -a
end

# Get images
function di
    docker images
end

# Run interactive container, e.g., $dki base /bin/bash
function dki
    docker run -i -t -P
end

# Execute interactive container, e.g., $dex base /bin/bash
function dex
    docker exec -i -t
end

# Remove all running containers
function drmf
    docker stop (docker ps -a -q)
        docker rm (docker ps -a -q)
end

# Exec into a running container
function jumpinto
    docker exec -it $1 bash
end

# --------------------------------
# AWS Functions
# --------------------------------

function aws-get-p2
    set -g -x instanceId  (aws ec2 describe-instances --filters "Name=instance-state-name,Values=stopped,Name=instance-type,Values=p2.xlarge" --query "Reservations[0].Instances[0].InstanceId")
    echo $instanceId
end

function aws-get-t2
    set -g -x instanceId (aws ec2 describe-instances --filters "Name=instance-state-name,Values=stopped,Name=instance-type,Values=t2.xlarge" --query "Reservations[0].Instances[0].InstanceId")
    echo $instanceId
end

function aws-start
    aws ec2 start-instances --instance-ids $instanceId
    aws ec2 wait instance-running --instance-ids $instanceId
    set -g -x instanceIp (aws ec2 describe-instances --filters "Name=instance-id,Values=$instanceId" --query "Reservations[0].Instances[0].PublicIpAddress")
    echo $instanceIp
end

function aws-ip
    set -g -x instanceIp (aws ec2 describe-instances --filters "Name=instance-id,Values=$instanceId" --query "Reservations[0].Instances[0].PublicIpAddress")
    echo $instanceIp
end

function aws-ssh
    ssh -i ~/.ssh/aws-key-fast-ai.pem ubuntu@$instanceIp
end
function  aws-stop
    aws ec2 stop-instances --instance-ids $instanceId
end
function  aws-state
    aws ec2 describe-instances --instance-ids $instanceId --query "Reservations[0].Instances[0].State.Name"
end

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/dinesh/Downloads/google-cloud-sdk/path.fish.inc' ]; if type source > /dev/null; source '/Users/dinesh/Downloads/google-cloud-sdk/path.fish.inc'; else; . '/Users/dinesh/Downloads/google-cloud-sdk/path.fish.inc'; end; end


# Fish git prompt
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate ''
set __fish_git_prompt_showupstream 'none'
set -g fish_prompt_pwd_dir_length 3

# colored man output
# from http://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
setenv LESS_TERMCAP_mb \e'[01;31m'       # begin blinking
setenv LESS_TERMCAP_md \e'[01;38;5;74m'  # begin bold
setenv LESS_TERMCAP_me \e'[0m'           # end mode
setenv LESS_TERMCAP_se \e'[0m'           # end standout-mode
setenv LESS_TERMCAP_so \e'[38;5;246m'    # begin standout-mode - info box
setenv LESS_TERMCAP_ue \e'[0m'           # end underline
setenv LESS_TERMCAP_us \e'[04;38;5;146m' # begin underline

function fish_prompt
	set_color brblack
	echo -n "["(date "+%H:%M")"] "
	set_color blue
	echo -n (hostname)
	if [ $PWD != $HOME ]
		set_color brblack
		echo -n ':'
		set_color yellow
		echo -n (basename $PWD)
	end
	set_color green
	printf '%s ' (__fish_git_prompt)
	set_color red
	echo -n '| '
	set_color normal
end

alias vim=nvim

if command -v exa > /dev/null
	abbr -a l 'exa'
	abbr -a ls 'exa'
	abbr -a ll 'exa -l'
	abbr -a lll 'exa -la'
else
	abbr -a l 'ls'
	abbr -a ll 'ls -l'
	abbr -a lll 'ls -la'
end

if test -f /usr/local/share/autojump/autojump.fish;
	source /usr/local/share/autojump/autojump.fish;
end

