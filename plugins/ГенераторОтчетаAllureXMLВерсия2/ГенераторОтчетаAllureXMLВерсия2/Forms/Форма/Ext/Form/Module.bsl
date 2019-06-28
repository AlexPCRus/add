﻿&НаКлиенте
Перем КонтекстЯдра;

// { Plugin interface

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра = КонтекстЯдраПараметр;
КонецПроцедуры

&НаКлиенте
Функция ОписаниеПлагина(ВозможныеТипыПлагинов) Экспорт
	Возврат ОписаниеПлагинаНаСервере(ВозможныеТипыПлагинов);
КонецФункции

&НаСервере
Функция ОписаниеПлагинаНаСервере(ВозможныеТипыПлагинов)
	Возврат ЭтотОбъектНаСервере().ОписаниеПлагина(ВозможныеТипыПлагинов);
КонецФункции
// } Plugin interface

// { Report generator interface
&НаКлиенте
Функция СоздатьОтчет(Знач КонтекстЯдра, Знач РезультатыТестирования) Экспорт
	Объект.ТипыУзловДереваТестов = КонтекстЯдра.Плагин("ПостроительДереваТестов").Объект.ТипыУзловДереваТестов;
	Объект.ИконкиУзловДереваТестов = КонтекстЯдра.Плагин("ПостроительДереваТестов").Объект.ИконкиУзловДереваТестов;
	Объект.СостоянияТестов = КонтекстЯдра.Объект.СостоянияТестов;
	Возврат СоздатьОтчетНаСервере(РезультатыТестирования);
КонецФункции

&НаСервере
Функция СоздатьОтчетНаСервере(Знач РезультатыТестирования)
	Результат = ЭтотОбъектНаСервере().СоздатьОтчетНаСервере(РезультатыТестирования);
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура Показать(Отчет) Экспорт
	Отчет.Показать();
КонецПроцедуры

&НаКлиенте
Процедура Экспортировать(Отчет, ПутьКОтчету, ОписаниеЗавершения = Неопределено) Экспорт

	Если КонтекстЯдра.ЕстьПоддержкаАсинхронныхВызовов Тогда

		НачатьПолучениеИмениФайла(Отчет, ПутьКОтчету, ОписаниеЗавершения);

	Иначе

		ИмяФайла = ПолучитьУникальноеИмяФайла(ПутьКОтчету);
		НачатьСохранениеОтчета(Отчет, ИмяФайла, ОписаниеЗавершения);
	КонецЕсли;

КонецПроцедуры
// } Report generator interface

&НаКлиенте
Процедура НачатьСохранениеОтчета(Отчет, ИмяФайла, ОписаниеОповещения = Неопределено)

	ПроверитьИмяФайлаРезультатаAllureСервер(ИмяФайла);

	СтрокаJSON = Отчет.ПолучитьТекст();

	// Запись файла с кодировкой "UTF-8", а не "UTF-8 with BOM"
	ЗаписьТекста = Новый ЗаписьТекста(ИмяФайла, КодировкаТекста.ANSI);
	ЗаписьТекста.Закрыть();

	ЗаписьТекста = Новый ЗаписьТекста(ИмяФайла,,, Истина);
	ЗаписьТекста.Записать(СтрокаJSON);
	ЗаписьТекста.Закрыть();

	Если ОписаниеОповещения <> Неопределено Тогда

		ВыполнитьОбработкуОповещения(ОписаниеОповещения);

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НачатьПолучениеИмениФайла(Отчет, ПутьКОтчету, ОписаниеЗавершения)
	Файл = Новый Файл(ПутьКОтчету);
	Файл.НачатьПроверкуСуществования(Новый ОписаниеОповещения("НачатьПроверкуСуществованияЗавершение", ЭтаФорма, Новый Структура("Файл,Отчет,ОписаниеЗавершения", Файл, Отчет, ОписаниеЗавершения)));
КонецПроцедуры

&НаКлиенте
Процедура НачатьПроверкуСуществованияЗавершение(Существует, ДополнительныеПараметры) Экспорт

	Файл = ДополнительныеПараметры.Файл;
	ОписаниеЗавершения = ДополнительныеПараметры.ОписаниеЗавершения;
	Отчет = ДополнительныеПараметры.Отчет;
	Если Существует Тогда

		Файл.НачатьПроверкуЭтоКаталог(Новый ОписаниеОповещения("НачатьПроверкуЭтоКаталогЗавершение", ЭтаФорма, Новый Структура("Файл,Отчет,ОписаниеЗавершения", Файл, Отчет, ОписаниеЗавершения)));

	Иначе

		ИмяФайла =  СформироватьИмя(Файл.Путь);
		НачатьСохранениеОтчета(Отчет, ИмяФайла, ОписаниеЗавершения);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НачатьПроверкуЭтоКаталогЗавершение(ЭтоКаталог, ДополнительныеПараметры) Экспорт

	Файл = ДополнительныеПараметры.Файл;
	ОписаниеЗавершения = ДополнительныеПараметры.ОписаниеЗавершения;
	Отчет = ДополнительныеПараметры.Отчет;

	Если ЭтоКаталог Тогда

		ПутьОтчета = Файл.ПолноеИмя;

	Иначе

		ПутьОтчета =  Файл.Путь;

	КонецЕсли;
	ПутьОтчета = СформироватьИмя(ПутьОтчета);
	НачатьСохранениеОтчета(Отчет, ПутьОтчета, ОписаниеЗавершения);
КонецПроцедуры

&НаКлиенте
Функция СформироватьИмя(Путь)

	ГУИД = Новый УникальныйИдентификатор;

	ИмяФайла = СтрЗаменить("%1-result.json", "%1", ГУИД);

	ИмяФайла = Путь + "/" + ИмяФайла;

	Возврат ИмяФайла;
КонецФункции
&НаКлиенте
Процедура НачатьЭкспорт(ОбработкаОповещения, Отчет, ПолныйПутьФайла) Экспорт

	Экспортировать(Отчет, ПолныйПутьФайла, ОбработкаОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьРезультатТеста(Знач КонтекстЯдра, Знач РезультатТеста, Знач ПолныйПутьФайла) Экспорт
	Объект.СостоянияТестов = КонтекстЯдра.Объект.СостоянияТестов;
	// ЗаписатьРезультатТестаНаСервере(РезультатТеста, ПолныйПутьФайла);
	Отчет = ПолучитьРезультатТестаНаСервере(РезультатТеста);
	// ИмяФайла = ПолучитьУникальноеИмяФайла(ПолныйПутьФайла);
	// Экспортировать(Отчет, ИмяФайла);
	Экспортировать(Отчет, ПолныйПутьФайла);
КонецПроцедуры

&НаСервере
Функция ПолучитьРезультатТестаНаСервере(Знач РезультатТеста) Экспорт
	Возврат ЭтотОбъектНаСервере().ПолучитьРезультатТестаНаСервере(РезультатТеста);
КонецФункции
// &НаСервере
// Процедура ЗаписатьРезультатТестаНаСервере(Знач РезультатТеста, Знач ПолныйПутьФайла) Экспорт
// 	ЭтотОбъектНаСервере().ЗаписатьРезультатТестаНаСервере(РезультатТеста, ПолныйПутьФайла);
// КонецПроцедуры

// { Helpers

&НаКлиенте
// задаю уникальное имя для возможности получения одного отчета allure по разным тестовым наборам
Функция ПолучитьУникальноеИмяФайла(Знач ПутьКОтчету)

	Файл = Новый Файл(ПутьКОтчету);

	ПутьКаталога = ?(Файл.Существует() И Файл.ЭтоКаталог(), Файл.ПолноеИмя, Файл.Путь);

	ИмяФайла = СформироватьИмя(ПутьКаталога);

	Возврат ИмяФайла;

КонецФункции

&НаСервере
Процедура ПроверитьИмяФайлаРезультатаAllureСервер(ИмяФайла) Экспорт

	Сообщение = "Уникальное имя файла " + ИмяФайла;
	ЗаписьЖурналаРегистрации("xUnitFor1C.ГенераторОтчетаAllureXMLВерсия2", УровеньЖурналаРегистрации.Информация, , , Сообщение);

	ЭтотОбъектНаСервере().ПроверитьИмяФайлаРезультатаAllure(ИмяФайла);
КонецПроцедуры

&НаСервере
Функция ЭтотОбъектНаСервере()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции
// } Helpers
