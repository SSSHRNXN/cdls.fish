function cdls 
	#╭╮╰╯─
	set -l cdls_version "0.0.0.1"

	set -l "CLEAN_TTY" "True"

	set -g c (set_color cyan)
	set -g b (set_color blue --bold --underline)
	set -g br (set_color -b red)
	set -g bc (set_color -b cyan)
	set -g nc (set_color normal)
	set -g rc (set_color -r)

	set -l values_for_printf "│ %-12s │ %-10s │ %-10s │ %-16s │ %s\n"

	function ls_for_cdls
		set -l values_for_printf "│ %-12s │ %-10s │ %-10s │ %-16s │ %s\n"
	
		#$1 = permissions $3=userowner $4=groupowner date=dateofcreation $8=file/directory
		ls -la --time-style=long-iso | awk \
			-v values="$values_for_printf" \
			-v blue="$b" \
			-v cyan="$c" '
			NR>1 {
				date = $6 " " $7 
				colorize_if_dir = substr($1,1,1) == "d" ? cyan"/" : blue
				printf values, $1, $3, $4, date, colorize_if_dir $8 "\033[0m"
			}'
	end

	set -l file_dir (dirname $argv)

	if [ "$CLEAN_TTY" = "True" ]
		clear
	end

	if [ -f "$argv" ]
		echo ""
		echo -e "$br$argv$nc - is a file!"
		echo ""


		echo "1 - nano"
		echo "2 - vim"
		echo "q" - "quit"

		read -p "" var_for_redactor
		switch $var_for_redactor
			case "1" 
				nano "$argv"
			case "2" 
				vim "$argv"
			case "*"
				if [ "$CLEAN_TTY" = "True" ]
					clear
					echo ""
					echo -e "$br$argv$nc - is a file!"
				end
					echo ""
		end
		if [ "$CLEAN_TTY" = "True" ]
			clear
			echo ""
			echo -e "$br$argv$nc - is a file!"
		end
			echo ""
	end

   	cd $argv 2>/dev/null

	echo "$PWD"
	echo "╭───────────────────────────────────────────────────────────╮"
	printf "$values_for_printf" "Permissions" "Userown" "Groupown" "Creation date"
	echo "├───────────────────────────────────────────────────────────┤"

	ls_for_cdls | head -n 45
	
	set -l counter_of_files (ls -la | wc -l)
	if [ "$counter_of_files" -gt 45 ]
		set -l value_of_contain_files (math "$counter_of_files-45")
		read -P "$rc Dir contains $value_of_contain_files files more, show them all? [y/n]:$nc" show_all_files
			switch $show_all_files
			case "y"
				printf '\033[1A\033[2K\r' 
				ls_for_cdls | tail -n +45 
				echo "╰───────────────────────────────────────────────────────────╯"
			case "*"
				printf '\033[1A\033[2K\r' 
				echo "╰─\/more─────────────────────────────────────────────more\/─╯"
			end
	else
		echo "╰───────────────────────────────────────────────────────────╯"
	end	


	commandline -r "cdls "
end
