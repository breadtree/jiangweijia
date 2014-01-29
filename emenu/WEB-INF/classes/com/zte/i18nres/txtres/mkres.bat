del userjsp_zh_CN.properties
del javamsg_zh_CN.properties
native2ascii  -encoding GBK userjsp_zh_CN(zh).properties   userjsp_zh_CN.properties
native2ascii  -encoding GBK javamsg_zh_CN(zh).properties   javamsg_zh_CN.properties

del userjsp_ar.properties 
del javamsg_ar.properties 
native2ascii  -encoding cp1256  userjsp_ar(ar).properties  userjsp_ar.properties
native2ascii  -encoding cp1256  javamsg_ar(ar).properties  javamsg_ar.properties

del userjsp_ru.properties
del javamsg_ru.properties
native2ascii  -encoding cp1251  userjsp_ru(ru).properties  userjsp_ru.properties
native2ascii  -encoding cp1251  javamsg_ru(ru).properties  javamsg_ru.properties

del userjsp_fr.properties
del javamsg_fr.properties
native2ascii  -encoding ISO-8859-1  userjsp_fr(fr).properties  userjsp_fr.properties
native2ascii  -encoding ISO-8859-1  javamsg_fr(fr).properties  javamsg_fr.properties