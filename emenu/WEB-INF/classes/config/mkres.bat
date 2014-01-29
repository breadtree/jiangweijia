del exception_zh_CN.properties
del taoinfo_zh_CN.properties
native2ascii  -encoding GBK exception_zh_CN(zh).properties   exception_zh_CN.properties
native2ascii  -encoding GBK taoinfo_zh_CN(zh).properties   taoinfo_zh_CN.properties

del exception_ar.properties
del taoinfo_ar.properties
native2ascii  -encoding cp1256  exception_ar(ar).properties  exception_ar.properties
native2ascii  -encoding cp1256  taoinfo_ar(ar).properties  taoinfo_ar.properties

del exception_ru.properties
del taoinfo_ru.properties
native2ascii  -encoding cp1251  exception_ru(ru).properties  exception_ru.properties
native2ascii  -encoding cp1251  taoinfo_ru(ru).properties  taoinfo_ru.properties

del exception_fr.properties
del taoinfo_fr.properties
native2ascii  -encoding ISO-8859-1  exception_fr(fr).properties  exception_fr.properties
native2ascii  -encoding ISO-8859-1  taoinfo_fr(fr).properties  taoinfo_fr.properties