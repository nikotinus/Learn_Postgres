there are several interesting functions in postgresql:

- *group by cube (аттр1, аттр2 и т.д.)* - выводит информацию для всех возможных сочетаний внутри группы:
аттр1 аттр2
null аттр2
аттр1 null
null null
- *group by rollup (attr1, attr2 ...)* - убирает сочетания по одному, начиная справа:
attr1 attr2
att1 null
null null

- *group by groupingsets ((attr1, attr2), ())* - группирует по заданным сетам:
attr1 attr2
null null

если задать **group by groupingsets ((attr1, attr2))** - это будет эквивалетно **group by attr1, attr2**
