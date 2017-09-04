﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СформироватьДеревоРабот(Параметры.Владелец, Параметры.Работы);
	УстановитьЗаголовокФормы(Параметры.Владелец);	
		 
КонецПроцедуры

#КонецОбласти

#Область ДеревоРабот

&НаСервере
Процедура СформироватьДеревоРабот(Проект, Работы)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(ВыработкаСотрудников.Период) КАК Период,
	|	ВыработкаСотрудников.Работа
	|ПОМЕСТИТЬ ВТ_ГрафикВыполнения
	|ИЗ
	|	РегистрНакопления.ВыработкаСотрудников КАК ВыработкаСотрудников
	|ГДЕ
	|	ВыработкаСотрудников.Проект = &Проект
	|
	|СГРУППИРОВАТЬ ПО
	|	ВыработкаСотрудников.Работа
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВыработкаСотрудников.Бригадир,
	|	ВыработкаСотрудников.Работа
	|ПОМЕСТИТЬ ВТ_ПоследнийБригадир
	|ИЗ
	|	РегистрНакопления.ВыработкаСотрудников КАК ВыработкаСотрудников
	|ГДЕ
	|	(ВыработкаСотрудников.Период, ВыработкаСотрудников.Работа) В
	|			(ВЫБРАТЬ
	|				Т.Период,
	|				Т.Работа
	|			ИЗ
	|				ВТ_ГрафикВыполнения КАК Т)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОценкиРаботСрезПоследних.Работа
	|ПОМЕСТИТЬ ВТ_РаботыСОценками
	|ИЗ
	|	РегистрСведений.ОценкиРабот.СрезПоследних(, Проект = &Проект) КАК ОценкиРаботСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА РеестрыРабот.Ссылка В (&Работы)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Флаг,
	|	РеестрыРабот.Ссылка КАК Работа,
	|	РеестрыРабот.Ссылка.Количество КАК Объем,
	|	ВыполненныеРаботыОбороты.КоличествоОборот КАК ВыполненоОтОбъема,
	|	ВТ_ПоследнийБригадир.Бригадир КАК Бригадир,
	|	ВЫБОР
	|		КОГДА ВТ_РаботыСОценками.Работа ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК РаботаОценена
	|ИЗ
	|	Справочник.РеестрыРабот КАК РеестрыРабот
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ВыполненныеРаботы.Обороты КАК ВыполненныеРаботыОбороты
	|		ПО (ВыполненныеРаботыОбороты.Работа = РеестрыРабот.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ПоследнийБригадир КАК ВТ_ПоследнийБригадир
	|		ПО (ВТ_ПоследнийБригадир.Работа = РеестрыРабот.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_РаботыСОценками КАК ВТ_РаботыСОценками
	|		ПО (ВТ_РаботыСОценками.Работа = РеестрыРабот.Ссылка)
	|ГДЕ
	|	РеестрыРабот.Владелец = &Проект
	|
	|УПОРЯДОЧИТЬ ПО
	|	Работа ИЕРАРХИЯ";
	
	Запрос.УстановитьПараметр("Проект", Проект);
	Запрос.УстановитьПараметр("Работы", Работы);
	
	Результат = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	ЗначениеВРеквизитФормы(Результат, "ДеревоРабот");

КонецПроцедуры

&НаКлиенте
Процедура ДеревоРаботФлагПриИзменении(Элемент)
	
	ИДТекущейСтроки = Элементы.ДеревоРабот.ТекущаяСтрока;

    Если ИДТекущейСтроки <> Неопределено Тогда

        ЭлементКоллекции = ЭтаФорма.ДеревоРабот.НайтиПоИдентификатору(ИДТекущейСтроки);

        Если ЭлементКоллекции.Флаг = 2 Тогда
            ЭлементКоллекции.Флаг = 0;
        КонецЕсли;

        УстановкаФлажков(ЭлементКоллекции, ЭлементКоллекции.Флаг);

        Родитель = ЭлементКоллекции.ПолучитьРодителя();
        Пока Родитель <> Неопределено Цикл
            Родитель.Флаг = ?(УстановленноДляВсех(ЭлементКоллекции), ЭлементКоллекции.Флаг, 2);
            ЭлементКоллекции = Родитель;
            Родитель = ЭлементКоллекции.ПолучитьРодителя();
        КонецЦикла;

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановкаФлажков(ЭлементКоллекции, ЗначениеПометки)

    ВложенныеЭлементы = ЭлементКоллекции.ПолучитьЭлементы();
    Для Каждого ТекЭлемент Из ВложенныеЭлементы Цикл
        ТекЭлемент.Флаг = ЗначениеПометки;
        УстановкаФлажков(ТекЭлемент, ТекЭлемент.Флаг);
    КонецЦикла;

КонецПроцедуры

&НаКлиенте
Функция УстановленноДляВсех(ЭлементКоллекции)

    СоседниеЭлементы = ЭлементКоллекции.ПолучитьРодителя().ПолучитьЭлементы();
    Для Каждого ТекЭлемент Из СоседниеЭлементы Цикл
        Если ТекЭлемент.Флаг <> ЭлементКоллекции.Флаг Тогда
            Возврат Ложь;
        КонецЕсли;
    КонецЦикла;
    Возврат Истина;

КонецФункции

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбранныеРаботы = ВыбратьРаботыНаСервере();
	ОповеститьОВыборе(ВыбранныеРаботы);
	
КонецПроцедуры

&НаСервере
Функция ВыбратьРаботыНаСервере()
	
	ВыбРаботы = Новый Массив;
	ВыбСтроки = РеквизитФормыВЗначение("ДеревоРабот", Тип("ДеревоЗначений")).Строки.НайтиСтроки(Новый Структура("Флаг", Истина), Истина);
	Для Каждого Стр Из ВыбСтроки Цикл
		Если НЕ Стр.Работа.ЭтоГруппа Тогда
			ВыбРаботы.Добавить(Стр.Работа);
		КонецЕсли;	
	КонецЦикла;
	
	Возврат ВыбРаботы;

КонецФункции

#КонецОбласти

&НаСервере
Процедура УстановитьЗаголовокФормы(Проект)
	
	ЭтаФорма.АвтоЗаголовок = Ложь;
	ЭтаФорма.Заголовок = "Выберите работы по проекту <"+Проект+">";
	
КонецПроцедуры






