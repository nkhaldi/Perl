#!/usr/bin/env perl

# Измените предыдущую программу так, чтобы совпадение также
# находилось в строках со словом Fred. Будут ли теперь найдены
# совпадения во входных строках Fred, frederick и Alfred?

use 5.024;

while (<>) {
	print if (/(F|f)red/);
}
