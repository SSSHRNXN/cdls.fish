function cdls 

	set -l cdls_version "0.0.0.1"

	set -l "CLEAN_TTY" "True"

	set -l c (set_color cyan)
	set -l br (set_color -b red)
	set -l bc (set_color -b cyan)
	set -l nc (set_color normal)

	set -l values_for_printf "│ %-14s │ %-10s │ %-10s │ %-16s │ %s\n"

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
	printf "$bc$values_for_printf" "permissions" "userown" "groupown" "date created" "file $nc"
	ls -la --time-style=long-iso | awk -v values="$values_for_printf" 'NR>1 {date = $6 " " $7; printf values, $1, $3, $4, date, "\033[36m" $8 "\033[0m"}'

	#	set -l counter_of_files (ls -la | wc -l)
	#if [ "$counter_of_files" -gt 35 ]
	#		read -p "Dir contains $counter_of_files files, show them all? [y/n]" show_all_files
	#		switch $show_all_files
	#		case "n"
	#				printf "$bc$values_for_printf" "permissions" "userown" "groupown" "date created" "file $nc"
	#			ls -la --time-style=long-iso | head -n 30 | awk -v values="$values_for_printf" 'NR>1 {date = $6 " " $7; printf values, $1, $3, $4, date, "\033[36m" $8 "\033[0m"}'
	#		case "y"
	#			printf "$bc$values_for_printf" "permissions" "userown" "groupown" "date created" "file $nc"
	#			ls -la --time-style=long-iso | awk -v values="$values_for_printf" 'NR>1 {date = $6 " " $7; printf values, $1, $3, $4, date, "\033[36m" $8 "\033[0m"}'
	#		end
	#end	

	commandline -r "cdls "
end
