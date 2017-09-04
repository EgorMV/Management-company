﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет список модулей библиотек и конфигурации, которые предоставляют
// основные сведения о себе: имя, версия, список обработчиков обновления
// а также зависимости от других библиотек.
//
// Состав обязательных процедур модуля см. в области ПрограммныйИнтерфейс
// общего модуля ОбновлениеИнформационнойБазыБСП.
//
// Параметры:
//  МодулиПодсистем - Массив - имена серверных общих модулей библиотек и конфигурации.
//                             Например: ОбновлениеИнформационнойБазыБРО - библиотека,
//                                       ОбновлениеИнформационнойБазыБП  - конфигурация.
//                    
// Примечание: модуль библиотеки стандартных подсистем ОбновлениеИнформационнойБазыБСП
// не требуется явно добавлять в массив МодулиПодсистем.
//
Процедура ПриДобавленииПодсистем(МодулиПодсистем) Экспорт
	
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыМенеджментФирмы");	
	
КонецПроцедуры

#КонецОбласти
