#!/bin/bash
start=`date +%s%N` # Время начала выполнения скрипта

file='Загрузки/price.csv' # Имя файла по умолчанию

exclusion=$HOME'/bin/exclusion_neocom'
convert='.convert' # Временный файл. После использования удаляется
tmp='.tmp' # Временный файл. После использования удаляется


# Скрипт для удаления ненужных строк из прайса.
# author Stanislav Podoba (SWaP)
# Version 2.0

#--Проверка на наличие введеннных аргументов

if [ $# -gt "0" ];then 
	file=$1
fi

#--Проверка существования файла--

cd $HOME #--Переходим в каталог с прайсом

if [ -f $file ];then
	il=`cat $file | wc -l` #--Собирается дополнительная информация( количество позиций в прайсе)
else
	echo -e '\e[0;32mФайл не существует!'
	sleep 10
	exit
fi

#--Выходной файл

date=`date +%d-%m-%Y"_"%H-%M`
save='neocom-'$date'.csv'

#--Проверка существования файла слов исключений
cd $HOME # Переходим в каталог с прайсом

if [ -f $exclusion ];then
	cat $file | iconv -c -f WINDOWS-1251 -t UTF-8 > $convert
	cat $exclusion | while read line
	do
		#--Очистка прайса от ненужных позиций по ключевым словам
		sed "/$line/d" $convert > $tmp
		cat $tmp > $convert
		echo $line #--Отображаются слова-исключения
	done			
	cat $tmp | iconv -c -f UTF-8 -t WINDOWS-1251 > $save
else
	exit
fi

#-- Системные подсчеты--------

	# Подсчет длины строки и вывод результата

	ol=`cat $save | wc -l`

	echo -e '\e[0;33mБыло: '$il
	echo -e '\e[0;33mОсталось: '$ol
	echo -e '\e[0;33mУдалено строк: '$[$il-$ol]

# Вывод информации о времени выполнения скрипта
end=`date +%s%N`
echo -e '\e[0;32mВремя выполнения:' $[$[$end-$start]/1000000] 'ms\e[0;37m'

`rm $file` # удаляется необработанный файл
`rm $convert` # удаляются временные файлы
`rm $tmp`
