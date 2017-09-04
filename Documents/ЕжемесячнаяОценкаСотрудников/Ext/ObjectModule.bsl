﻿
Функция ПолучитьОбязательныеРеквизиты() Экспорт 

	РеквизитыДляПроверки = Новый Структура;
	
    РеквизитыТЧ = Новый Структура();       
    РеквизитыТЧ.Вставить("Сотрудник",2);
    РеквизитыДляПроверки.Вставить("Сотрудники",РеквизитыТЧ);  
    Возврат РеквизитыДляПроверки;             
    
КонецФункции

Процедура ОбработкаПроведения(Отказ, Режим)

	// регистр ОценкиСотрудников
	Движения.ОценкиСотрудников.Записывать = Истина;
	Движения.ОценкиСотрудников.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОценкаСотрудниковОценки.Ссылка.Проект,
	|	ОценкаСотрудниковСотрудники.Сотрудник,
	|	ОценкаСотрудниковСотрудники.ОценкаИтоговая,
	|	ОценкаСотрудниковОценки.КритерийОценки,
	|	ОценкаСотрудниковОценки.Оценка КАК ОценкаПоКритерию,
	|	ОценкаСотрудниковСотрудники.Ссылка.ПериодРегистрации КАК Период,
	|	ОценкаСотрудниковСотрудники.Комментарий КАК КомментарийОценки,
	|	ОценкаСотрудниковСотрудники.КоличествоСмен
	|ИЗ
	|	Документ.ЕжемесячнаяОценкаСотрудников.Сотрудники КАК ОценкаСотрудниковСотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЕжемесячнаяОценкаСотрудников.Оценки КАК ОценкаСотрудниковОценки
	|		ПО ОценкаСотрудниковСотрудники.Ссылка = ОценкаСотрудниковОценки.Ссылка
	|			И ОценкаСотрудниковСотрудники.КлючСтроки = ОценкаСотрудниковОценки.КлючСтроки
	|ГДЕ
	|	ОценкаСотрудниковСотрудники.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Движения.ОценкиСотрудников.Загрузить(Запрос.Выполнить().Выгрузить());
	
	Движения.ОценкиСотрудников.Записать();
	
КонецПроцедуры
