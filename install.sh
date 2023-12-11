
directories=(
	"nvim"
)

function link {
	for dir in ${directories[@]}; do 
		stow -Sv --target=$HOME $dir
	done
}


function unlink {
	for dir in ${directories[@]}; do 
		stow -Dv --target=$HOME $dir
	done
}

if [ "$1" = "link" ]; then
	link
	exit 0 
fi

if [ "$1" = "unlink" ]; then
	unlink
	exit 0 
fi

echo "Invalid command, must be link/unlink."
exit 1
