﻿// Выполняет заполнение первоначальных значений при создании новых 
// объектов или открытии иных форм.
// Параметры:
//		Форма - форма, реквизиты которой необходимо заполнить.
//		ЗапрашиваемыеЗначения - структура с запрашиваемыми значениями.
//			Имя элемента структуры идентифицирует значение, которое 
//				необходимо заполнить.
//			Значение элемента структуры - путь к реквизиту формы, значение
//				которого необходимо заполнить.
//			Список поддерживаемых значений см. в описании ПолучитьЗначенияПоУмолчанию.
//
Процедура ЗаполнитьПервоначальныеЗначенияВФорме(Форма, ЗапрашиваемыеЗначения) Экспорт
	
	ФиксированныеЗначения = Новый Массив;
	Для Каждого ЗапрашиваемоеЗначение Из ЗапрашиваемыеЗначения Цикл
		Если ЗначениеЗаполнено(ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ЗапрашиваемоеЗначение.Значение)) Тогда
			ФиксированныеЗначения.Добавить(ЗапрашиваемоеЗначение.Ключ)
		КонецЕсли	
	КонецЦикла;

	ЗаполнитьЗначенияВФорме(Форма, ЗапрашиваемыеЗначения, ФиксированныеЗначения);
	
КонецПроцедуры

// Выполняет заполнение значений в форме на основании значений по умолчанию.
// 
// Параметры:
//		Форма - форма, реквизиты которой необходимо заполнить.
//		ЗапрашиваемыеЗначения - структура с запрашиваемыми значениями.
//			Имя элемента структуры идентифицирует значение, которое 
//				необходимо заполнить.
//			Значение элемента структуры - путь к реквизиту формы, значение
//				которого необходимо заполнить.
//			Список поддерживаемых значений см. в описании ПолучитьЗначенияПоУмолчанию.
//
//		ФиксированныеЗначения - (необязательный) массив, 
//				Содержит идентификаторы значений, 
//				которое не должны быть изменены при заполнении.
//
Процедура ЗаполнитьЗначенияВФорме(Форма, ЗапрашиваемыеЗначения, ФиксированныеЗначения = Неопределено) Экспорт
		
	ЗначенияЗаполняемыеПоУмолчанию = СписокДоступныхЗначенийПоУмолчанию();
	
	Для Каждого ЗапрашиваемоеЗначение Из ЗапрашиваемыеЗначения Цикл
		
		НайденноеЗначение = Неопределено;
		Если ЗначенияЗаполняемыеПоУмолчанию.Свойство(ЗапрашиваемоеЗначение.Ключ, НайденноеЗначение) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, ЗапрашиваемоеЗначение.Значение, НайденноеЗначение);
		КонецЕсли;	
		
	КонецЦикла;
	
КонецПроцедуры

// Массив поддерживаемых идентификаторов значений по умолчанию.
Функция СписокДоступныхЗначенийПоУмолчанию() Экспорт
	
	ЗначенияПоУмолчанию = Новый Структура;
	ЗначенияПоУмолчанию.Вставить("Месяц", НачалоМесяца(ТекущаяДата()));
	Возврат ЗначенияПоУмолчанию;
	
КонецФункции

