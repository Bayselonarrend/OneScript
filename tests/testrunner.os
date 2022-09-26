﻿//////////////////////////////////////////////////////////////////
// 
// Объект-помощник для приемочного и юнит-тестирования
//
//////////////////////////////////////////////////////////////////

Перем Пути;
Перем КомандаЗапуска;
Перем НаборТестов;
Перем РезультатТестирования;

Перем ПутьЛогФайлаJUnit;

Перем НомерТестаДляЗапуска;
Перем НаименованиеТестаДляЗапуска;

Перем Рефлектор;

Перем ЗначенияСостоянияТестов;
Перем СтруктураПараметровЗапуска;

Перем	НаборОшибок;
Перем	НаборНереализованныхТестов;

Перем	ВсегоТестов;
Перем	ВыводитьОшибкиПодробно;

Перем ВременныеФайлы;

//////////////////////////////////////////////////////////////////////////////
// Программный интерфейс
//

Процедура ПодробныеОписанияОшибок(Знач ВключитьПодробноеОписание) Экспорт
	ВыводитьОшибкиПодробно = ВключитьПодробноеОписание;
КонецПроцедуры

//{ МЕТОДЫ ДЛЯ ПРОВЕРКИ ЗНАЧЕНИЙ (assertions). 

Процедура Проверить(Условие, ДопСообщениеОшибки = "") Экспорт
	Если Не Условие Тогда
		СообщениеОшибки = "Переданный параметр ("+Формат(Условие, "БЛ=ложь; БИ=истина")+") не является Истиной, а хотели, чтобы являлся." + ФорматДСО(ДопСообщениеОшибки);
		ВызватьИсключение(СообщениеОшибки);
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьИстину(Условие, ДопСообщениеОшибки = "") Экспорт
	Проверить(Условие, ДопСообщениеОшибки);
КонецПроцедуры

Процедура ПроверитьЛожь(Условие, ДопСообщениеОшибки = "") Экспорт
	Если Условие Тогда
		СообщениеОшибки = "Переданный параметр ("+Формат(Условие, "БЛ=ложь; БИ=истина")+") не является Ложью, а хотели, чтобы являлся." + ФорматДСО(ДопСообщениеОшибки);
		ВызватьИсключение(СообщениеОшибки);
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьРавенствоДатСТочностью2Секунды(_Дата, _Дата2, ДопСообщениеОшибки = "") Экспорт
	Если _Дата < _Дата2-2 или _Дата > _Дата2+2 Тогда
		СообщениеОшибки = "Переданная дата ("+Формат(_Дата, "ДФ='dd.MM.yyyy HH:mm:ss'")+") не равна дате ("+Формат(_Дата2, "ДФ='dd.MM.yyyy HH:mm:ss'")+") с точностью до 2-х секунд, а хотели, чтобы они равнялись." + ФорматДСО(ДопСообщениеОшибки);
		ВызватьИсключение(СообщениеОшибки);
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьДату(_Дата, _Период, ДопСообщениеОшибки = "") Экспорт
	Если _Дата < _Период.ДатаНачала или _Дата > _Период.ДатаОкончания Тогда
		представление = ПредставлениеПериода(_Период.ДатаНачала, _Период.ДатаОкончания, "ФП = Истина");
		СообщениеОшибки = "Переданный параметр ("+Формат(_Дата, "ДФ='dd.MM.yyyy HH:mm:ss'")+") не входит в период "+представление+", а хотели, чтобы являлся." + ФорматДСО(ДопСообщениеОшибки);
		ВызватьИсключение(СообщениеОшибки);
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьРавенство(ПервоеЗначение, ВтороеЗначение, ДопСообщениеОшибки = "") Экспорт
	Если ПервоеЗначение <> ВтороеЗначение Тогда
		Если ТипЗнч(ПервоеЗначение) = Тип("Строка") и ТипЗнч(ВтороеЗначение) = Тип("Строка") Тогда
			ВызватьИсключение ИсключениеНеравенстваСтрок(ПервоеЗначение, ВтороеЗначение) + "
			|" + ДопСообщениеОшибки;
		КонецЕсли;
		
		СообщениеОшибки = "Сравниваемые значения ("+ПервоеЗначение+"; "+ВтороеЗначение+") не равны, а хотели, чтобы были равны." + ФорматДСО(ДопСообщениеОшибки);
		ВызватьИсключение(СообщениеОшибки);
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьНеРавенство(ПервоеЗначение, ВтороеЗначение, ДопСообщениеОшибки = "") Экспорт
	Если ПервоеЗначение = ВтороеЗначение Тогда
		СообщениеОшибки = "Сравниваемые значения ("+ПервоеЗначение+"; "+ВтороеЗначение+") равны, а хотели, чтобы были не равны." + ФорматДСО(ДопСообщениеОшибки);
		ВызватьИсключение(СообщениеОшибки);
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьБольше(_Больше, _Меньше, ДопСообщениеОшибки = "") Экспорт
	Если _Больше <= _Меньше Тогда
		СообщениеОшибки = "Первый параметр ("+_Больше+") меньше или равен второму ("+_Меньше+") а хотели, чтобы был больше." + ФорматДСО(ДопСообщениеОшибки);
		ВызватьИсключение(СообщениеОшибки);
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьБольшеИлиРавно(_Больше, _Меньше, ДопСообщениеОшибки = "") Экспорт
	Если _Больше < _Меньше Тогда
		СообщениеОшибки = "Первый параметр ("+_Больше+") меньше второго ("+_Меньше+") а хотели, чтобы был больше или равен." + ФорматДСО(ДопСообщениеОшибки);
		ВызватьИсключение(СообщениеОшибки);
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьМеньше(проверяемоеЗначение1, проверяемоеЗначение2, СообщениеОбОшибке = "") Экспорт
	Если проверяемоеЗначение1 >= проверяемоеЗначение2 Тогда
		ВызватьИсключение "Значение <"+проверяемоеЗначение1+"> больше или равно, чем <"+проверяемоеЗначение2+">, а ожидалось меньше"+
				ФорматДСО(СообщениеОбОшибке);
	КонецЕсли; 
КонецПроцедуры

Процедура ПроверитьМеньшеИлиРавно(проверяемоеЗначение1, проверяемоеЗначение2, СообщениеОбОшибке = "") Экспорт
	Если проверяемоеЗначение1 > проверяемоеЗначение2 Тогда
		ВызватьИсключение "Значение <"+проверяемоеЗначение1+"> больше, чем <"+проверяемоеЗначение2+">, а ожидалось меньше или равно"+
				ФорматДСО(СообщениеОбОшибке);
	КонецЕсли; 
КонецПроцедуры

// проверка идет через ЗначениеЗаполнено, но мутабельные значение всегда считаем заполненными
Процедура ПроверитьЗаполненность(ПроверяемоеЗначение, ДопСообщениеОшибки = "") Экспорт
    Попытка
        фЗаполнено = ЗначениеЗаполнено(ПроверяемоеЗначение);
    Исключение
        Возврат;
    КонецПопытки; 
    Если НЕ фЗаполнено Тогда
        ВызватьИсключение "Значение ("+ПроверяемоеЗначение+") не заполнено, а ожидалась заполненность" + ФорматДСО(ДопСообщениеОшибки);
    КонецЕсли; 
КонецПроцедуры

Процедура ПроверитьНеЗаполненность(ПроверяемоеЗначение, ДопСообщениеОшибки = "") Экспорт
	СообщениеОшибки = "Значение ("+ПроверяемоеЗначение+") заполнено, а ожидалась незаполненность" + ФорматДСО(ДопСообщениеОшибки);
	Попытка
        фЗаполнено = ЗначениеЗаполнено(ПроверяемоеЗначение);
    Исключение
        ВызватьИсключение СообщениеОшибки;
    КонецПопытки; 
    Если фЗаполнено Тогда
        ВызватьИсключение СообщениеОшибки;
    КонецЕсли; 
КонецПроцедуры

Процедура ПроверитьВхождение(строка, подстрокаПоиска, ДопСообщениеОшибки = "") Экспорт
	Если Найти(строка, подстрокаПоиска) = 0 Тогда
		СообщениеОшибки = "Искали в <"+строка+"> подстроку <"+подстрокаПоиска+">, но не нашли." + ФорматДСО(ДопСообщениеОшибки);
		ВызватьИсключение(СообщениеОшибки);
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьКодСОшибкой( Код, Ошибка, ДопСообщениеОшибки = "" ) Экспорт
	Попытка
		Сценарий = ЗагрузитьСценарийИзСтроки(Код);
		СообщениеОшибки = "Ожидали ошибку '"+Ошибка+"', но ее не было";
	Исключение
		ОписаниеОшибки = ИнформацияОбОшибке().Описание;
		Если Найти(ОписаниеОшибки, Ошибка ) = 0 Тогда
			СообщениеОшибки = "Ожидали ошибку '"+Ошибка+"', а была ошибка '"+ОписаниеОшибки+"'";
		Иначе
			Возврат;
		КонецЕсли;
	КонецПопытки;
	ВызватьИсключение(СообщениеОшибки + ФорматДСО(ДопСообщениеОшибки));
КонецПроцедуры

Процедура ПроверитьТип(Значение, ТипИлиИмяТипа, ДопСообщениеОшибки = "") Экспорт
	
	Если ТипЗнч(ТипИлиИмяТипа) = Тип("Строка") Тогда
		ОжидаемыйТип = Тип(ТипИлиИмяТипа);
	ИначеЕсли ТипЗнч(ТипИлиИмяТипа) = Тип("Тип") Тогда
		ОжидаемыйТип = ТипИлиИмяТипа;
	Иначе
		ТекстИсключения = СтрШаблон(
			"ПроверитьТип: Тип значения параметра ТипИлиИмяТипа должен быть <Тип> или <Строка>, а получили <%1>.%2",
			ТипЗнч(ТипИлиИмяТипа),
			ФорматДСО(ДопСообщениеОшибки));
		ВызватьИсключение(ТекстИсключения);
	КонецЕсли;
	Если ТипЗнч(Значение) <> ОжидаемыйТип Тогда
		ОшибкаПроверки = СтрШаблон(
			"Типом значения <%1> является <%2>, а ожидался тип <%3>.%4",
			Значение, ТипЗнч(Значение), ТипИлиИмяТипа, ФорматДСО(ДопСообщениеОшибки));
		ВызватьИсключение(ОшибкаПроверки);
	КонецЕсли;
КонецПроцедуры

Процедура ТестПройден() Экспорт
КонецПроцедуры

Процедура ТестПровален(ДопСообщениеОшибки) Экспорт
	СообщениеОшибки = "Тест провален." + ФорматДСО(ДопСообщениеОшибки);
	ВызватьИсключение(СообщениеОшибки);
КонецПроцедуры

Функция ЭкранироватьПереводыСтрок(Знач Строка)
	Возврат СтрЗаменить(СтрЗаменить(Строка, Символы.ПС, "\n"), Символы.ВК, "\r");
КонецФункции

Функция ИсключениеНеравенстваСтрок(ПервоеЗначение, ВтороеЗначение)
	ДиапазонОтНачала = 5;
	ДиапазонВКонце   = 5;
	СтрокаНабора = "          "; // длина = 2*ДиапазонОтНачала

	МинДлина = Мин(СтрДлина(ПервоеЗначение), СтрДлина(ВтороеЗначение));
	ИндексРазличия = МинДлина + 1;
	Для Сч = 1 По МинДлина Цикл
		Символ1 = Сред(ПервоеЗначение, Сч, 1);
		Символ2 = Сред(ВтороеЗначение, Сч, 1);
		Если Символ1 <> Символ2 Тогда
			ИндексРазличия = Сч;
			Прервать;
		КонецЕсли;
	КонецЦикла;

	ОтступНачала = ИндексРазличия - ДиапазонОтНачала;
	Если ОтступНачала <= 0 Тогда
		ОтступНачала = 1;
	КонецЕсли;
	
	ФрагментПервой = Сред(ПервоеЗначение, ОтступНачала, ДиапазонОтНачала);
	ФрагментПервойЭкр = ЭкранироватьПереводыСтрок(ФрагментПервой);

	Префикс = ДиапазонОтНачала;
	Если ИндексРазличия <= ДиапазонОтНачала Тогда
		Префикс = ИндексРазличия - 1;
	КонецЕсли;
	Префикс = Префикс + СтрДлина(ФрагментПервойЭкр) - СтрДлина(ФрагментПервой);

	ФрагментПервойЭкр = ФрагментПервойЭкр +
        ЭкранироватьПереводыСтрок(Сред(ПервоеЗначение, ОтступНачала+ДиапазонОтНачала, ДиапазонВКонце));
    
	ФрагментВторойЭкр = ЭкранироватьПереводыСтрок(Сред(ВтороеЗначение, ОтступНачала, ДиапазонОтНачала+ДиапазонВКонце)); 

	Возврат "Различия в позиции " + ИндексРазличия + ".
	|Строка 1:`" + ФрагментПервойЭкр + "`
	|          " + Лев(СтрокаНабора, Префикс) + "^
	|Строка 2:`" + ФрагментВторойЭкр + "`";
КонецФункции

//}

// { временные файлы
Функция ИмяВременногоФайла(Знач Расширение = "tmp") Экспорт
	Если ВременныеФайлы = Неопределено Тогда
		ВременныеФайлы = Новый Массив;
	КонецЕсли;
	
	ИмяВремФайла = ПолучитьИмяВременногоФайла(Расширение);
	ВременныеФайлы.Добавить(ИмяВремФайла);
	Возврат ИмяВремФайла;
КонецФункции

Процедура УдалитьВременныеФайлы() Экспорт

	Если ВременныеФайлы <> Неопределено Тогда
		Для Каждого ИмяФайла Из ВременныеФайлы Цикл
			Попытка
				УдалитьФайлы(ИмяФайла);
			Исключение
				Сообщить("Не удален временный файл: " + ИмяФайла + "
				|-" + ОписаниеОшибки());
			КонецПопытки;
		КонецЦикла;
		
		ВременныеФайлы.Очистить();
		
	КонецЕсли;
	
КонецПроцедуры
// }

//{ Выполнение тестов - экспортные методы

Процедура ВыполнитьТесты(МассивПараметров) Экспорт
	Сообщить("Версия приложения " + (Новый СистемнаяИнформация).Версия);
	Инициализация();
	РезультатТестирования = ЗначенияСостоянияТестов.НеВыполнялся;
	
	Если Не ОбработатьПараметрыЗапуска(МассивПараметров) Тогда
		РезультатТестирования = ЗначенияСостоянияТестов.НеВыполнялся;
	КонецЕсли; 
	УдалитьВременныеФайлы();
КонецПроцедуры

Функция ПолучитьРезультатТестирования() Экспорт
	Возврат РезультатТестирования;
КонецФункции

//}

Функция ПолучитьПараметрыЗапуска(МассивПараметров) Экспорт
	Перем ПутьЛогФайла;
	
	Если МассивПараметров.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НомерТестаДляЗапуска = Неопределено;
	НаименованиеТестаДляЗапуска = Неопределено;
	ПутьЛогФайла = Неопределено;
	
	НомерПараметраПутьКТестам = -1;
	
	КомандаЗапуска = НРег(МассивПараметров[0]);
	Если КомандаЗапуска = СтруктураПараметровЗапуска.ПоказатьСписок Тогда
		путьКТестам = МассивПараметров[1];
	ИначеЕсли КомандаЗапуска = СтруктураПараметровЗапуска.Запустить Тогда
		НомерПараметраПутьКТестам = 1;
	ИначеЕсли КомандаЗапуска = СтруктураПараметровЗапуска.ЗапуститьКаталог Тогда
		НомерПараметраПутьКТестам = 1;
		
	Иначе
		КомандаЗапуска = СтруктураПараметровЗапуска.Запустить;
		НомерПараметраПутьКТестам = 0;
	КонецЕсли;

	НомерОчередногоПараметра = НомерПараметраПутьКТестам;
	
	Если КомандаЗапуска = СтруктураПараметровЗапуска.Запустить Тогда
		путьКТестам = МассивПараметров[НомерПараметраПутьКТестам];
		НомерОчередногоПараметра = НомерОчередногоПараметра + 1;
		Если МассивПараметров.Количество() > НомерОчередногоПараметра Тогда
			НомерОчередногоПараметра = НомерПараметраПутьКТестам+1;
			ИД_Теста = МассивПараметров[НомерОчередногоПараметра];

			Если НРег(ИД_Теста) <> СтруктураПараметровЗапуска.Режим_ПутьЛогФайла Тогда
				Если ВСтрокеСодержатсяТолькоЦифры(ИД_Теста) Тогда
					НомерТестаДляЗапуска = Число(ИД_Теста);
				Иначе
					НаименованиеТестаДляЗапуска = ИД_Теста;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли КомандаЗапуска = СтруктураПараметровЗапуска.ЗапуститьКаталог Тогда

		Если МассивПараметров.Количество() > НомерПараметраПутьКТестам Тогда
			путьКТестам = МассивПараметров[НомерПараметраПутьКТестам];
			НомерОчередногоПараметра = НомерОчередногоПараметра + 1;
		Иначе
			путьКТестам = ТекущийКаталог();
		КонецЕсли;

	КонецЕсли;
	
	Если МассивПараметров.Количество() > НомерОчередногоПараметра и (КомандаЗапуска = СтруктураПараметровЗапуска.Запустить или КомандаЗапуска = СтруктураПараметровЗапуска.ЗапуститьКаталог ) Тогда
		Режим = НРег(МассивПараметров[НомерОчередногоПараметра]);
		Если Режим = СтруктураПараметровЗапуска.Режим_ПутьЛогФайла Тогда
			Если МассивПараметров.Количество() > НомерОчередногоПараметра+1 Тогда
				НомерОчередногоПараметра = НомерОчередногоПараметра+1;
				ПутьЛогФайла = МассивПараметров[НомерОчередногоПараметра];
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыЗапуска = Новый Структура;
	ПараметрыЗапуска.Вставить("Команда", КомандаЗапуска);
	ПараметрыЗапуска.Вставить("ПутьКТестам", путьКТестам);
	ПараметрыЗапуска.Вставить("НаименованиеТестаДляЗапуска", НаименованиеТестаДляЗапуска);
	ПараметрыЗапуска.Вставить("НомерТестаДляЗапуска", НомерТестаДляЗапуска);
	ПараметрыЗапуска.Вставить("ПутьЛогФайлаJUnit", ПутьЛогФайла);
	
	Возврат ПараметрыЗапуска;
КонецФункции

Функция ОбработатьПараметрыЗапуска(МассивПараметров)
	
	ПараметрыЗапуска = ПолучитьПараметрыЗапуска(МассивПараметров);
	Если Не ЗначениеЗаполнено(МассивПараметров) Тогда
		Возврат Ложь;
	КонецЕсли;
	КомандаЗапуска = ПараметрыЗапуска.Команда;
	путьКТестам = ПараметрыЗапуска.путьКТестам;
	НомерТестаДляЗапуска = ПараметрыЗапуска.НомерТестаДляЗапуска;
	НаименованиеТестаДляЗапуска = ПараметрыЗапуска.НаименованиеТестаДляЗапуска;
	ПутьЛогФайлаJUnit = ПараметрыЗапуска.ПутьЛогФайлаJUnit;
	
	Файл = Новый Файл(путьКТестам);
	Если Не Файл.Существует() Тогда
		ВызватьИсключение "Не найден файл/каталог "+путьКТестам;
	КонецЕсли;

	Если КомандаЗапуска = СтруктураПараметровЗапуска.Запустить Тогда
		Пути.Добавить(ПутьКТестам);
	ИначеЕсли КомандаЗапуска = СтруктураПараметровЗапуска.ПоказатьСписок Тогда
		Пути.Добавить(ПутьКТестам);
	ИначеЕсли КомандаЗапуска = СтруктураПараметровЗапуска.ЗапуститьКаталог Тогда
		Файлы = НайтиФайлы(ПутьКТестам, "*.os");
		Для Каждого Файл Из Файлы Цикл
			Если Файл.ИмяБезРасширения <> "testrunner" Тогда
				Пути.Добавить(Файл.ПолноеИмя);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если КомандаЗапуска = СтруктураПараметровЗапуска.ПоказатьСписок Тогда
		Сообщить("Список тестов:");
	КонецЕсли;

	Если Не ЗагрузитьТесты() Тогда
		Сообщить("Не были загружены тесты");
	КонецЕсли;

	Если КомандаЗапуска = СтруктураПараметровЗапуска.Запустить или КомандаЗапуска = СтруктураПараметровЗапуска.ЗапуститьКаталог Тогда
		ВыполнитьВсеТесты();
	
		Сообщить(" ");

		Если КомандаЗапуска <> СтруктураПараметровЗапуска.ПоказатьСписок Тогда
			Если РезультатТестирования > ЗначенияСостоянияТестов.НеРеализован Тогда
				Сообщить("ОШИБКА: Есть непрошедшие тесты. Красная полоса", СтатусСообщения.Важное);
			ИначеЕсли РезультатТестирования > ЗначенияСостоянияТестов.Прошел Тогда
				Сообщить("ОШИБКА: Есть нереализованные тесты. Желтая полоса", СтатусСообщения.Внимание);
			Иначе
				Сообщить("ОК. Зеленая полоса", СтатусСообщения.Информация);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

Функция СоздатьСтруктуруПараметровЗапуска() Экспорт
	СтруктураПараметровЗапуска = Новый Структура;
	СтруктураПараметровЗапуска.Вставить("Запустить", НРег("-run"));
	СтруктураПараметровЗапуска.Вставить("ЗапуститьКаталог", НРег("-runall"));
	СтруктураПараметровЗапуска.Вставить("ПоказатьСписок", НРег("-show"));
	СтруктураПараметровЗапуска.Вставить("Режим_ПутьЛогФайла", НРег("xddReportPath"));
	Возврат СтруктураПараметровЗапуска;
КонецФункции

Функция ЗагрузитьТесты()
	Перем НомерТестаСохр;
	Перем Рез;
	
	Рез = Истина;
	
	Для Каждого ПутьТеста Из Пути Цикл
		Файл = Новый Файл(ПутьТеста);
		Если Файл.ЭтоКаталог() Тогда
			ВызватьИсключение "Пока не умею обрабатывать каталоги тестов";
		Иначе
			ПолноеИмяТестовогоСлучая = Файл.ПолноеИмя;
			ИмяКлассаТеста = СтрЗаменить(Файл.ИмяБезРасширения,"-","")+СтрЗаменить(Строка(Новый УникальныйИдентификатор),"-","");
			Если КомандаЗапуска = СтруктураПараметровЗапуска.ПоказатьСписок Тогда
				Сообщить("  Файл теста "+ПолноеИмяТестовогоСлучая);
			КонецЕсли;
			Попытка
				ПодключитьСценарий(Файл.ПолноеИмя, ИмяКлассаТеста);
				Тест = Новый(ИмяКлассаТеста);
			Исключение
				ИнфоОшибки = ИнформацияОбОшибке();
				Если ВыводитьОшибкиПодробно Тогда
					текстОшибки = ИнфоОшибки.ПодробноеОписаниеОшибки();
				Иначе
					текстОшибки = ПодробноеПредставлениеОшибки(ИнфоОшибки);
				КонецЕсли;
				Сообщить("Не удалось загрузить тест "+ПолноеИмяТестовогоСлучая+Символы.ПС+
					текстОшибки);
				Рез = Ложь;
				РезультатТестирования = ЗначенияСостоянияТестов.Сломался;
				Продолжить;
			КонецПопытки;
			
			МассивТестовыхСлучаев = ПолучитьТестовыеСлучаи(Тест, ПолноеИмяТестовогоСлучая);
			Если МассивТестовыхСлучаев = Неопределено Тогда
				Сообщить("Нет тестовых случаев в файле " + Файл.ПолноеИмя);
				Продолжить;
			КонецЕсли;
			
			Для Каждого ТестовыйСлучай Из МассивТестовыхСлучаев Цикл
				Если ЭтоСтрока(ТестовыйСлучай) Тогда
					ИмяТестовогоСлучая = ТестовыйСлучай;
					ПараметрыТеста = Неопределено;
					ПредставлениеТеста = ИмяТестовогоСлучая;
				Иначе
					ВызватьИсключение "Не умею обрабатывать описание тестового случая из ПолучитьСписокТестов, отличный от строки"; //TODO
				КонецЕсли;
				
				ОписаниеТеста = Новый Структура;
				ОписаниеТеста.Вставить("ТестОбъект", Тест);
				ОписаниеТеста.Вставить("ИмяКласса", ИмяКлассаТеста);
				ОписаниеТеста.Вставить("ПолноеИмя", ПолноеИмяТестовогоСлучая);
				ОписаниеТеста.Вставить("Параметры", ПараметрыТеста);
				ОписаниеТеста.Вставить("ИмяМетода", ИмяТестовогоСлучая);

				НаборТестов.Добавить(ОписаниеТеста);
				
				НомерТеста = НаборТестов.Количество()-1;
				Если КомандаЗапуска = СтруктураПараметровЗапуска.ПоказатьСписок Тогда
					
					Шаблон = СтрШаблон("%1: %2",
						Формат(НомерТеста, "ЧЦ=4; ЧВН=; ЧГ=0; ЧН=0000"),
						ИмяТестовогоСлучая);

					Сообщить(Шаблон);

				ИначеЕсли КомандаЗапуска = СтруктураПараметровЗапуска.Запустить или КомандаЗапуска = СтруктураПараметровЗапуска.ЗапуститьКаталог Тогда
					Если НаименованиеТестаДляЗапуска = Неопределено Тогда
						Если НомерТеста = НомерТестаДляЗапуска Тогда
							НомерТестаСохр = НомерТеста;
						КонецЕсли;
					Иначе
						Если НРег(НаименованиеТестаДляЗапуска) = НРег(ИмяТестовогоСлучая) Тогда
							НомерТестаСохр = НомерТеста;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;			
		КонецЕсли;
	КонецЦикла;
	
	Если НомерТестаСохр <> Неопределено Тогда
		ОписаниеТеста = НаборТестов[НомерТестаСохр];
		НаборТестов.Очистить();
		НаборТестов.Добавить(ОписаниеТеста);
	КонецЕсли;
	
	Возврат Рез;
КонецФункции

Функция ВыполнитьВсеТесты()
	Если НаборТестов.Количество() > 0 Тогда
		НаборОшибок = Новый Соответствие;
		НаборНереализованныхТестов = Новый Соответствие;
		ДатаНачала = ТекущаяДата();
		
		СоздаватьОтчетТестированияВФорматеJUnitXML = ЗначениеЗаполнено(ПутьЛогФайлаJUnit);
		Если СоздаватьОтчетТестированияВФорматеJUnitXML Тогда
			ЗаписьXML = Неопределено;
			НачатьЗаписьВФайлОтчетаТестированияВФорматеJUnitXML(ЗаписьXML);
		КонецЕсли;
		
		Для Сч = 0 По НаборТестов.Количество() - 1 Цикл
			ОписаниеТеста = НаборТестов[Сч];
			НовыйРезультатТестирования = ВыполнитьТест(ОписаниеТеста, Сч);		
			РезультатТестирования = ЗапомнитьСамоеХудшееСостояние(РезультатТестирования, НовыйРезультатТестирования);			
		КонецЦикла;
		
		ВывестиЛогТестирования();
		
		Если СоздаватьОтчетТестированияВФорматеJUnitXML Тогда
			ЗавершитьЗаписьВФайлОтчетаТестированияВФорматеJUnitXML(ЗаписьXML, ДатаНачала);
		КонецЕсли;
	КонецЕсли;
КонецФункции

Процедура ВывестиЛогТестирования()
	пройденоТестов = НаборТестов.Количество() - НаборОшибок.Количество() - НаборНереализованныхТестов.Количество();
	
	Сообщить(" ");	
	Сообщить("------------------------------------------------------------");
	Сообщить("                       Общая статистика                     ");
	Сообщить("------------------------------------------------------------");
	
	Сообщить(" ");
	Сообщить("Тестов пройдено: " + пройденоТестов, СтатусСообщения.Информация);

    КоличествоОшибок = НаборОшибок.Количество();
	Сообщить(" ");
	Сообщить("Тестов не пройдено: " + КоличествоОшибок, 
		?(КоличествоОшибок>0, СтатусСообщения.Важное, СтатусСообщения.Информация) );
	
	Если КоличествоОшибок > 0 Тогда
		Сч = 0;
		Для Каждого КлючЗначение Из НаборОшибок Цикл
			Сч = Сч + 1;
			ОписаниеТеста = КлючЗначение.Ключ;
			Сообщить("    * " + ОписаниеТеста.ИмяМетода + " : <" + ОписаниеТеста.ПолноеИмя + ">");
		КонецЦикла;
	КонецЕсли;

    КоличествоНереализованных = НаборНереализованныхТестов.Количество();
	Сообщить(" ");
	Сообщить("Тестов не реализовано \ пропущено: " + КоличествоНереализованных, 
		?(КоличествоНереализованных>0, СтатусСообщения.Внимание, СтатусСообщения.Информация) );

	Если КоличествоНереализованных > 0 Тогда
		Сч = 0;
		Для Каждого КлючЗначение Из НаборНереализованныхТестов Цикл
			Сч = Сч + 1;
			ОписаниеТеста = КлючЗначение.Ключ;
			Сообщить("    * " + ОписаниеТеста.ИмяМетода + " : <" + ОписаниеТеста.ПолноеИмя + ">");
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Процедура НачатьЗаписьВФайлОтчетаТестированияВФорматеJUnitXML(ЗаписьXML)
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	
КонецПроцедуры

Процедура ЗавершитьЗаписьВФайлОтчетаТестированияВФорматеJUnitXML(ЗаписьXML, ДатаНачала)
	ПроверитьНеРавенство(НаборТестов.Количество(), 0);
	
	ВсегоТестов = НаборТестов.Количество();
	КоличествоОшибок = НаборОшибок.Количество();
	КоличествоНереализованныхТестов = НаборНереализованныхТестов.Количество();
	
	ВремяВыполнения = ТекущаяДата() - ДатаНачала;
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("testsuites");
	ЗаписьXML.ЗаписатьАтрибут("tests", XMLСтрока(ВсегоТестов));
	ЗаписьXML.ЗаписатьАтрибут("name", XMLСтрока("xUnitFor1C")); //TODO: указывать путь к набору тестов. 
	ЗаписьXML.ЗаписатьАтрибут("time", XMLСтрока(ВремяВыполнения));
	ЗаписьXML.ЗаписатьАтрибут("failures", XMLСтрока(КоличествоОшибок));
	ЗаписьXML.ЗаписатьАтрибут("skipped", XMLСтрока(КоличествоНереализованныхТестов)); // или disabled

	ЗаписьXML.ЗаписатьНачалоЭлемента("testsuite");	

	ФайлТестаВрем = Новый Файл(НаборТестов[0].ПолноеИмя);
	Если КомандаЗапуска = СтруктураПараметровЗапуска.Запустить Тогда
		ПутьНабора = ФайлТестаВрем.Имя;
	Иначе
		ПутьНабора = ФайлТестаВрем.Путь;
	КонецЕсли;
	ИмяНабора = ИмяТекущегоТеста(ПутьНабора);
	ФайлТеста = Новый Файл(ПутьНабора);
	
	ЗаписьXML.ЗаписатьАтрибут("name", ИмяНабора);
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("properties");	
	ЗаписьXML.ЗаписатьКонецЭлемента();

	Для Каждого ОписаниеТеста Из НаборТестов Цикл
		ЗаполнитьРезультатТестовогоСлучая(ЗаписьXML, ОписаниеТеста, НаборОшибок, НаборНереализованныхТестов);
	КонецЦикла;	

	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	СтрокаХМЛ = ЗаписьXML.Закрыть();

	ПутьОтчетаВФорматеJUnitxml = Новый Файл(ПутьФайлаОтчетаТестированияВФорматеJUnitXML()+"/"+ФайлТеста.Имя+".xml");
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(ПутьОтчетаВФорматеJUnitxml.ПолноеИмя);
	ЗаписьXML.ЗаписатьБезОбработки(СтрокаХМЛ);// таким образом файл будет записан всего один раз, и не будет проблем с обработкой на билд-сервере TeamCity
	ЗаписьXML.Закрыть();
	Сообщить(" ");
	Сообщить("Путь к лог-файлу проверки в формате Ant.JUnit <"+ПутьОтчетаВФорматеJUnitxml.ПолноеИмя+">");
	
КонецПроцедуры

Процедура ЗаполнитьРезультатТестовогоСлучая(ЗаписьXML, ОписаниеТеста, НаборОшибок, НаборНереализованныхТестов)
		
	ЗаписьXML.ЗаписатьНачалоЭлемента("testcase");
	ЗаписьXML.ЗаписатьАтрибут("classname", ИмяТекущегоТеста(ОписаниеТеста.ПолноеИмя));
	ЗаписьXML.ЗаписатьАтрибут("name", ОписаниеТеста.ИмяМетода);
	
	СтруктураОшибки		= НаборОшибок.Получить(ОписаниеТеста);
	
	Если СтруктураОшибки = Неопределено Тогда
		СтруктураОшибки		= НаборНереализованныхТестов.Получить(ОписаниеТеста);
	КонецЕсли;
	
	Если СтруктураОшибки <> Неопределено Тогда
		СтрокаРезультат = ?(СтруктураОшибки.СостояниеВыполнения = ЗначенияСостоянияТестов.Сломался, "failure", "skipped");
		
		ЗаписьXML.ЗаписатьАтрибут("status", СтрокаРезультат);
		ЗаписьXML.ЗаписатьНачалоЭлемента(СтрокаРезультат);

		СтрокаОписание = СтруктураОшибки.Описание;
		// TODO: НайтиНедопустимыеСимволыXML()
		XMLОписание = XMLСтрока(СтрокаОписание); 
		ЗаписьXML.ЗаписатьАтрибут("message", XMLОписание);
		
		ЗаписьXML.ЗаписатьКонецЭлемента();
	Иначе
		ЗаписьXML.ЗаписатьАтрибут("status", "passed");
	КонецЕсли;
	
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
КонецПроцедуры

Функция ПутьФайлаОтчетаТестированияВФорматеJUnitXML()
	Возврат ?(ЗначениеЗаполнено(ПутьЛогФайлаJUnit), ПутьЛогФайлаJUnit, ТекущийКаталог());
КонецФункции

Функция ИмяТекущегоТеста(ПолныйПуть)
	Файл = Новый Файл(ПолныйПуть);
	Возврат Файл.ИмяБезРасширения;
КонецФункции

Функция ВыполнитьТест(ОписаниеТеста, Сч)
	Перем Рез;
	
	Тест = ОписаниеТеста.ТестОбъект;
	ИмяМетода = ОписаниеТеста.ИмяМетода;
	
	Успешно = ВыполнитьПроцедуруТестовогоСлучая(Тест, "ПередЗапускомТеста", ИмяМетода, ОписаниеТеста);
	Если Не Успешно Тогда
		Рез = ЗначенияСостоянияТестов.Сломался;
	Иначе
		Если Не Рефлектор.МетодСуществует(Тест, ИмяМетода) Тогда
			ПоказатьИнформациюПоТесту(ОписаниеТеста, Сч, ИмяМетода);
			Рез = ВывестиОшибкуВыполненияТеста(ЗначенияСостоянияТестов.НеРеализован, "Не найден тестовый метод "+ ИмяМетода, ОписаниеТеста, "", Неопределено);
			Сообщить("  ");
		Иначе
			Попытка
				Рефлектор.ВызватьМетод(Тест, ИмяМетода);
				
				Рез = ЗначенияСостоянияТестов.Прошел;
			Исключение
				ПоказатьИнформациюПоТесту(ОписаниеТеста, Сч, ИмяМетода);
				ИнфоОшибки = ИнформацияОбОшибке();
				текстОшибки = КраткоеПредставлениеОшибки(ИнфоОшибки) +  ПолучитьОписаниеСтекаВызовов(ИнфоОшибки);
				Если ВыводитьОшибкиПодробно Тогда
					текстОшибки = текстОшибки + "
					|" + ИнфоОшибки.ПодробноеОписаниеОшибки();
				КонецЕсли;
				Рез = ВывестиОшибкуВыполненияТеста(ЗначенияСостоянияТестов.Сломался, "", ОписаниеТеста, текстОшибки, ИнфоОшибки);
				Сообщить("  ");
			КонецПопытки;
		КонецЕсли;
		
		Успешно = ВыполнитьПроцедуруТестовогоСлучая(Тест, "ПослеЗапускаТеста", ИмяМетода, ОписаниеТеста);
		Если Не Успешно Тогда
			Рез = ЗначенияСостоянияТестов.Сломался;
		КонецЕсли;
	КонецЕсли;

	Возврат Рез;	
КонецФункции

Функция ПолучитьОписаниеСтекаВызовов(Знач ИнфоОшибки)
	
	Стек = ИнфоОшибки.ПолучитьСтекВызовов();
	ТекстСтека = "";
	Отступ = "                          ";
	ДлинаОтступа = СтрДлина(Отступ);
	Сч = 0;
	Для Каждого Кадр Из Стек Цикл
		Если Сч > ДлинаОтступа Тогда
			Сч = 1;
		КонецЕсли;

		ТекстСтека = ТекстСтека + Символы.ПС 
		+ Лев(Отступ, Сч) + СтрШаблон("-> %1 (%2), %3", Кадр.Метод, Кадр.НомерСтроки, Кадр.ИмяМодуля);
		Сч = Сч + 2;
	КонецЦикла;

	Возврат ТекстСтека;

КонецФункции

Функция ВывестиОшибкуВыполненияТеста(СостояниеВыполнения, ПредставлениеОшибки, ОписаниеТеста, текстОшибки, ИнфоОшибки)
	ИмяМетода = ОписаниеТеста.ИмяМетода;

	сообщение = ?(ПредставлениеОшибки="", "", ПредставлениеОшибки + Символы.ПС) + 
		"Тест: <" + ИмяМетода + ">"  + Символы.ПС +
		"Файл: <" + ОписаниеТеста.ПолноеИмя + "> " + Символы.ПС + 
		"Сообщение: " + текстОшибки;
	Если СостояниеВыполнения = ЗначенияСостоянияТестов.НеРеализован Тогда
		ВывестиПредупреждение(сообщение);
	Иначе
		ВывестиОшибку(сообщение);
	КонецЕсли;
	
	СтруктураОшибки = Новый Структура();
	
	СтруктураОшибки.Вставить("ИмяТестовогоНабора", ИмяМетода);
	
	стИнфоОшибки = Новый Структура("СостояниеВыполнения,ИмяМодуля,ИсходнаяСтрока,НомерСтроки,Описание");
	Если ИнфоОшибки <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(стИнфоОшибки, ИнфоОшибки);
	КонецЕсли;
	стИнфоОшибки.Вставить("Причина",  Неопределено);
	
	стИнфоОшибкиЦикл = стИнфоОшибки;
	Если ИнфоОшибки <> Неопределено Тогда
		ИнфоОшибки = ИнфоОшибки.Причина;
	КонецЕсли;
	Пока ИнфоОшибки <> Неопределено Цикл
		стИнфоОшибкиЦикл.Причина = Новый Структура("ИмяМодуля,ИсходнаяСтрока,НомерСтроки,Описание");
		стИнфоОшибкиЦикл = стИнфоОшибкиЦикл.Причина;
		ЗаполнитьЗначенияСвойств(стИнфоОшибкиЦикл, ИнфоОшибки);
		стИнфоОшибкиЦикл.Вставить("Причина",  Неопределено);

		ИнфоОшибки = ИнфоОшибки.Причина;
	КонецЦикла;
	
	ИмяТестовогоСлучаяДляОписанияОшибки = ИмяМетода;
	
	СтруктураОшибки.Вставить("ИмяТестовогоСлучая", ИмяТестовогоСлучаяДляОписанияОшибки);
	СтруктураОшибки.Вставить("СостояниеВыполнения",  СостояниеВыполнения);
	
	СтруктураОшибки.Вставить("Описание",              текстОшибки);
	СтруктураОшибки.Вставить("ИнфоОшибки",            стИнфоОшибки);
	СтруктураОшибки.Вставить("ПолныйПуть",            ОписаниеТеста.ПолноеИмя);
	
	Если СостояниеВыполнения = ЗначенияСостоянияТестов.Сломался Тогда
		НаборОшибок.Вставить(ОписаниеТеста, СтруктураОшибки);
	Иначе
		НаборНереализованныхТестов.Вставить(ОписаниеТеста, СтруктураОшибки);
	КонецЕсли;
	
	Возврат СостояниеВыполнения;
	
КонецФункции

Функция ВыполнитьПроцедуруТестовогоСлучая(Тест, ИмяПроцедуры, ИмяТестовогоСлучая, ОписаниеТеста)
	Успешно = Ложь;
	
	ПолноеИмя = ОписаниеТеста.ПолноеИмя;
	Попытка
		Рефлектор.ВызватьМетод(Тест,ИмяПроцедуры);
		Успешно = Истина;
	Исключение
		ИнфоОшибки = ИнформацияОбОшибке();
		текстОшибки = ОписаниеОшибки();
		
		Если ЕстьОшибка_МетодОбъектаНеОбнаружен(текстОшибки, ИмяПроцедуры) Тогда
			Успешно = Истина;
		Иначе
			Рез = ВывестиОшибкуВыполненияТеста(ЗначенияСостоянияТестов.Сломался, "Упал метод "+ИмяПроцедуры, ОписаниеТеста, текстОшибки, ИнфоОшибки);
		КонецЕсли;
	КонецПопытки;

	Возврат Успешно;
КонецФункции

Функция ПолучитьТестовыеСлучаи(ТестОбъект, ПолноеИмяОбъекта)

	Попытка
        
		МассивТестовыхСлучаев = ТестОбъект.ПолучитьСписокТестов(ЭтотОбъект);
		
	Исключение
		текстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		// TODO если не использовать переменную ниже, а поставить вызов метода в условие, то будет глюк - внутрь условия не попадаем !
		ЕстьОшибка_МетодОбъектаНеОбнаружен = ЕстьОшибка_МетодОбъектаНеОбнаружен(текстОшибки, "ПолучитьСписокТестов");
		Если НЕ ЕстьОшибка_МетодОбъектаНеОбнаружен Тогда
		
			текстОшибки = ?(ВыводитьОшибкиПодробно, ИнформацияОбОшибке().ПодробноеОписаниеОшибки(), ОписаниеОшибки());
			
			ВывестиОшибку("Набор тестов не загружен: " + ПолноеИмяОбъекта + "
			|	Ошибка получения списка тестовых случаев: " + текстОшибки);
			
			ТестОбъект = Неопределено;
		КонецЕсли;
		
		Возврат Неопределено;			
				
	КонецПопытки;

	Если ТипЗнч(МассивТестовыхСлучаев) <> Тип("Массив") Тогда
		
		ВывестиОшибку("Набор тестов не загружен: " + ПолноеИмяОбъекта + "
				|	Ошибка получения списка тестовых случаев: вместо массива имен тестовых случаев получен объект <" + Строка(ТипЗнч(МассивТестовыхСлучаев)) + ">");
		ТестОбъект = Неопределено;
		Возврат Неопределено;			
		
	КонецЕсли;
	
	Если НЕ ПроверитьМассивТестовыхСлучаев(МассивТестовыхСлучаев, ТестОбъект, ПолноеИмяОбъекта) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат МассивТестовыхСлучаев;
		
КонецФункции

Функция ПроверитьМассивТестовыхСлучаев(МассивТестовыхСлучаев, ТестОбъект, ПолноеИмяОбъекта)
	Для каждого данныеТеста из МассивТестовыхСлучаев Цикл
		Если ТипЗнч(данныеТеста) = Тип("Строка") Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТипЗнч(данныеТеста) <> Тип("Структура") Тогда
			ВывестиОшибку("Набор тестов не загружен: " + ПолноеИмяОбъекта + "
			|	Ошибка получения структуры описания тестового случая: " + ОписаниеОшибки());
			Возврат Ложь;
		КонецЕсли;
		Если НЕ данныеТеста.Свойство("ИмяТеста") Тогда
			ВывестиОшибку("Набор тестов не загружен: " + ПолноеИмяОбъекта + "
			|	Не задано имя теста в структуре описания тестового случая: " + ОписаниеОшибки());
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	Возврат Истина;
КонецФункции

Функция ЕстьОшибка_МетодОбъектаНеОбнаружен(текстОшибки, имяМетода)
	Результат = Ложь;
	Если (Найти(текстОшибки, "Метод объекта не обнаружен (") > 0 
		ИЛИ Найти(текстОшибки, "Object method not found (") > 0)
		И (Найти(текстОшибки, ИмяМетода) > 0)  Тогда
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Процедура ПоказатьИнформациюПоТесту(ОписаниеТеста, Знач Номер, Знач Тест)
	Сообщить("---------------------------------------------------------");
	Сообщить(" ");
	Сообщить("Тест №" + Строка(Номер) + ": " + Тест);
	Сообщить(" ");
КонецПроцедуры

// Устанавливает новое текущее состояние выполнения тестов
// в соответствии с приоритетами состояний:
// 		Красное - заменяет все другие состояния
// 		Желтое - заменяет только зеленое состояние
// 		Зеленое - заменяет только серое состояние (тест не выполнялся ни разу).
Функция ЗапомнитьСамоеХудшееСостояние(ТекущееСостояние, НовоеСостояние)
	
	ТекущееСостояние = Макс(ТекущееСостояние, НовоеСостояние);
	Возврат ТекущееСостояние;
	
КонецФункции

Функция ПредставлениеПериода(ДатаНачала, ДатаОкончания, ФорматнаяСтрока = Неопределено)
	Возврат "с "+ДатаНачала+" по "+ДатаОкончания;
КонецФункции

Функция ЭтоСтрока(Значение)
	Возврат Строка(Значение) = Значение;
КонецФункции

Функция ФорматДСО(ДопСообщениеОшибки)
	Если ДопСообщениеОшибки = "" Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат Символы.ПС + ДопСообщениеОшибки;
КонецФункции

Функция ВСтрокеСодержатсяТолькоЦифры(Знач ИсходнаяСтрока) Экспорт
	
	рез = Ложь;
	ДлинаСтроки = СтрДлина(ИсходнаяСтрока);
	Для Сч = 1 По ДлинаСтроки Цикл
		ТекущийСимвол = КодСимвола(Сред(ИсходнаяСтрока, Сч, 1));
		Если 48 <= ТекущийСимвол И ТекущийСимвол <= 57 Тогда
			рез = Истина;
		Иначе
			рез = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Возврат рез;	
КонецФункции

Процедура СоздатьСостояниеТестов()
	//{ Состояния тестов - ВАЖЕН порядок заполнения в мЗначенияСостоянияТестов, используется в ЗапомнитьСамоеХудшееСостояние
	ЗначенияСостоянияТестов = Новый Структура;
	ЗначенияСостоянияТестов.Вставить("НеВыполнялся", -1);
	ЗначенияСостоянияТестов.Вставить("Прошел"		, 0); // код 0 используется в командной строке для показа нормального завершения
	ЗначенияСостоянияТестов.Вставить("НеРеализован", 2);
	ЗначенияСостоянияТестов.Вставить("Сломался"	, 3);
	//} Состояния тестов
КонецПроцедуры

// Выводит сообщение. В тестах ВСЕГДА должна использоваться ВМЕСТО метода Сообщить().
// 

Функция ВывестиПредупреждение(Ошибка) Экспорт	
	
	НужныйТекстОшибки = Ошибка;
	
	ВывестиСообщение("ПРЕДУПРЕЖДЕНИЕ: " + НужныйТекстОшибки, СтатусСообщения.Внимание);

	Возврат НужныйТекстОшибки;	
КонецФункции

Функция ВывестиСообщение(ТекстСообщения, Статус = Неопределено) Экспорт	
	Если Статус = Неопределено Тогда
		Статус = СтатусСообщения.Обычное;
	КонецЕсли;
	
	Сообщить(ТекстСообщения, Статус);	
КонецФункции

// Вызывает исключение с заданным текстом ошибки для прерывания выполнения тестового случая.
// 
Функция ПрерватьТест(ТекстОшибки) Экспорт
	
	ВызватьИсключение ТекстОшибки;
	
КонецФункции

Функция ВывестиОшибку(Ошибка) Экспорт
	
	НужныйТекстОшибки = Ошибка;
	
	ВывестиСообщение("ОШИБКА: " + НужныйТекстОшибки, СтатусСообщения.Важное);

	Возврат НужныйТекстОшибки;
КонецФункции

Процедура Инициализация()
	Пути = Новый Массив;
	НаборТестов = Новый Массив;
	Рефлектор = Новый Рефлектор;

	СоздатьСостояниеТестов();
	СоздатьСтруктуруПараметровЗапуска();
	
	РезультатТестирования = ЗначенияСостоянияТестов.НеВыполнялся;
КонецПроцедуры

ВыводитьОшибкиПодробно = ПолучитьПеременнуюСреды("TESTRUNNER_VERBOSE") = "1";;

ВыполнитьТесты(АргументыКоманднойСтроки);

ЗавершитьРаботу(ПолучитьРезультатТестирования());
