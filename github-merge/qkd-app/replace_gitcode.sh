#!/bin/sh

# tested on Ubuntu 22.04

github_url='https://github.com/david921518/qkd-app/blob/master'
gitcode_url='https://gitcode.com/david921518/qkd-app/blob/gitcode'
ignore_files=("")

rm -rf ./main_tmp
mkdir -p ./main_tmp

rm -rf ./gitcode/*

cp -af ./main/* ./main_tmp/
cp -af ./main/* ./gitcode/

cd ./main_tmp/
files=$(find .)
cd ../

for filename in $files
do
	if [ -f ./main_tmp/$filename ]; then
		echo "./main_tmp/$filename is regular file"
		matched='false';
		for elem in "${ignore_files[@]}"; do
			if [[ "$elem" == "$filename" ]]; then
				matched='true';
			fi
		done
		if [[ "$matched" == 'false' ]]; then
			echo "replace $filename"
			sed "s^$github_url^$gitcode_url^" "./main_tmp/$filename" > "./gitcode/$filename"
		else
			echo "ignore $filename"
		fi
	else
		echo "./main_tmp/$filename is not regular file"
	fi
done

rm -rf ./main_tmp/

# git commit to github
cd ./gitcode/
git add *
git commit -S -a -m "merge with main branch"
git push origin gitcode
cd ../
