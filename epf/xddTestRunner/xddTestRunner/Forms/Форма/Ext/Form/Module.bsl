﻿Перем ЭтоПакетныйЗапуск Экспорт; // Флаг определяет выполнен ли пакетный запуск
// { События формы
Процедура ПриОткрытии()
	ИспользоватьПрямыеПутиФайлов = Истина;
	
	ЗагрузитьПлагины();
	КэшироватьПеречисленияПлагинов();
	
	ПервичнаяНастройка();

	ОбновитьКнопкиИсторииЗагрузкиТестов();
	ЭтаФорма.Заголовок = ЭтотОбъект.ЗаголовокФормы();
	
	КаталогПроекта = КаталогВременныхФайлов();

	ЭтоПакетныйЗапуск = ЗначениеЗаполнено(ПараметрЗапуска);
	Если ЭтоПакетныйЗапуск Тогда
		ВыполнитьПакетныйЗапуск(ПараметрЗапуска);
	Иначе
		ПерезагрузитьПоследниеТестыПоИстории();
	КонецЕсли;
КонецПроцедуры

Процедура ПриЗакрытии()
	ЭтотОбъект.СохранитьНастройки();
	СброситьЦиклическиеСсылки();
КонецПроцедуры

Процедура ОбработатьСобытиеВыполненияТестов(Знач ИмяСобытия, Знач Параметр) Экспорт
     Если ИмяСобытия = ЭтотОбъект.ВозможныеСобытия.ВыполненТестовыйМетод Тогда
		 Если Параметр.Состояние = СостоянияТестов.НеРеализован Тогда
			 Если ЭлементыФормы.ИндикаторВыполнения.ЦветРамки <> WebЦвета.Красный Тогда
				 ЭлементыФормы.ИндикаторВыполнения.ЦветРамки = WebЦвета.Золотой;
			 КонецЕсли;
		 ИначеЕсли Параметр.Состояние = СостоянияТестов.Сломан Тогда
			 ЭлементыФормы.ИндикаторВыполнения.ЦветРамки = WebЦвета.Красный;
		 КонецЕсли;
		 ЭлементыФормы.ИндикаторВыполнения.Значение = ЭлементыФормы.ИндикаторВыполнения.Значение + 1;
     КонецЕсли;
КонецПроцедуры
// } События формы

// { Управляющие воздействия пользователя
Процедура КнопкаВыполнитьВсеТестыНажатие(Элемент)
	ВыполнитьТестыНаКлиенте();
КонецПроцедуры

Процедура ВыполнитьТестыНаКлиенте(Знач Фильтр = Неопределено)
	Если ЗначениеЗаполнено(ЭтаФорма.ДеревоОтЗагрузчика) Тогда
		ОчиститьСообщения();
		
		ПервичнаяНастройка();
		
		КоличествоТестовыхМетодов = ЭтотОбъект.ПолучитьКоличествоТестовыхМетодов(ЭтаФорма.ДеревоОтЗагрузчика, Фильтр);
		ИнициализироватьИндикаторВыполнения(КоличествоТестовыхМетодов);
		
		РезультатыТестирования = ВыполнитьТесты(ЭтаФорма.Загрузчик, ЭтаФорма.ДеревоОтЗагрузчика, Фильтр, ЭтаФорма);
		
		ОбновитьДеревоТестовНаОснованииРезультатовТестирования(ДеревоТестов.Строки[0], РезультатыТестирования);
		
		ГенераторОтчетаMXL = Плагин("ГенераторОтчетаMXL");
		Отчет = ГенераторОтчетаMXL.СоздатьОтчет(ЭтотОбъект, РезультатыТестирования);
		ГенераторОтчетаMXL.Показать(Отчет);
		
		//ГенераторОтчетаMXL = Плагин("ГенераторОтчетаJUnitXML_TFS");
		//Отчет = ГенераторОтчетаMXL.СоздатьОтчет(ЭтотОбъект, РезультатыТестирования);
		//ГенераторОтчетаMXL.Показать(Отчет);
	КонецЕсли;
КонецПроцедуры

Процедура КнопкаВыполнитьВыделенныеТестыНажатие(Элемент)
	Фильтр = Новый Массив;
	ВыделенныеСтроки = ЭлементыФормы.ДеревоТестов.ВыделенныеСтроки;
	Для каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		Фильтр.Добавить(Новый УникальныйИдентификатор(ВыделеннаяСтрока.Ключ));
	КонецЦикла;
	Если Фильтр.Количество() > 0 Тогда
		ВыполнитьТестыНаКлиенте(Фильтр);
	КонецЕсли;
КонецПроцедуры

Процедура КнопкаЗагрузитьТестыНажатие(Элемент)
	ЗагрузчикПоУмолчанию = ЭтотОбъект.ЗагрузчикПоУмолчанию();
	ИдентификаторЗагрузчикаПоУмолчанию = ЗагрузчикПоУмолчанию.ОписаниеПлагина(ЭтотОбъект.ТипыПлагинов).Идентификатор;
	Подключаемый_ИнтерактивныйВызовЗагрузчика(Новый Структура("Имя", ИдентификаторЗагрузчикаПоУмолчанию));
КонецПроцедуры

Процедура КнопкаПерезагрузитьПерезагрузитьБраузерТестирования(Кнопка)

	Для каждого МетаФорма Из ЭтаФорма.Метаданные().Формы Цикл
		ТекФорма = ПолучитьФорму(МетаФорма); // может возвращать неопределено, если есть управляемая форма
		Если ТекФорма <> Неопределено И ТекФорма.Открыта() Тогда
			СброситьЦиклическиеСсылки();
			ТекФорма.Закрыть();
			Если ТекФорма = ЭтаФорма Тогда
				НайденноеИмяФайла = Неопределено;
				// Для встроенного в состав конфигурации браузера тестов
				// открываем форму обработки заново
				Если ЭтоВстроеннаяОбработка Тогда
					ЭтотОбъект.ПолучитьФорму(МетаФорма.Имя).Открыть();	
				Иначе
					Выполнить("НайденноеИмяФайла = ЭтотОбъект.ИспользуемоеИмяФайла;");
					ВнешниеОбработки.Создать(НайденноеИмяФайла, Ложь).ПолучитьФорму(МетаФорма.Имя).Открыть();
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура СброситьЦиклическиеСсылки()
	ЭтотОбъект.Плагины = Неопределено;
	Загрузчик = Неопределено;
КонецПроцедуры

Процедура ПерезагрузитьПоследниеТестыПоИстории(Элемент = Неопределено)
	
	ПерезагрузитьНастройкиИзФайла();
	
	ИсторияЗагрузкиТестов = ЭтотОбъект.Настройки.ИсторияЗагрузкиТестов;
	Если ИсторияЗагрузкиТестов.Количество() > 0 Тогда
		ЭлементИстории = ИсторияЗагрузкиТестов[0];
		Попытка
			ЗагрузитьТесты(ЭлементИстории.ИдентификаторЗагрузчика, ЭлементИстории.Путь);
		Исключение
			// TODO
			Сообщить("Не удалось загрузить тесты из истории <" + ЭлементИстории.ИдентификаторЗагрузчика + ": " + ЭлементИстории.Путь + ">" + Символы.ПС + ОписаниеОшибки());
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

Процедура КнопкаИнструментыГенераторМакетовДанных(Кнопка)
	ОткрытьИнструмент("СериализаторMXL", ПолучитьПутьКПлагинам());
КонецПроцедуры

Процедура КнопкаИнструментыПоказатьГУИД(Кнопка)
	ОткрытьИнструмент("xddGuidShow");
КонецПроцедуры

Процедура КнопкаИнструменты_bddRunner(Кнопка)
	ОткрытьИнструмент("bddRunner", ПолучитьПутьКПлагинам() + "/../");
КонецПроцедуры

Процедура КнопкаИнструментыКонвертерТестов(Кнопка)
	ОткрытьИнструмент("xddTestsConvertIntoRebornFormat");
КонецПроцедуры

Процедура КнопкаЗагрузитьТестыЗагрузитьНастройкиИзФайла(Кнопка)

	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбора.Заголовок = "Выберите файл настройки xUnirFor1C";
	ДиалогВыбора.Фильтр = "Настройки (*.json)|*.json";
	ДиалогВыбора.МножественныйВыбор = Ложь;
	ДиалогВыбора.ПроверятьСуществованиеФайла = Истина;
	ДиалогВыбора.ПолноеИмяФайла = ПутьФайлаНастроек();
	
	ОповещениеВыбора = Новый ОписаниеОповещения("ЗагрузитьНастройкиИзФайлаЗавершение", ЭтаФорма);
	ДиалогВыбора.Показать(ОповещениеВыбора);
	
КонецПроцедуры

// } Управляющие воздействия пользователя

// { Плагины
Процедура ЗагрузитьПлагины()
	ЭтотОбъект.Плагины = Новый Структура;
	
	// Если браузер тестов встроен в состав конфигурации, то плагины
	// получаем из встроеной подсистемы xUnitFor1C.Plugins
	Если ЭтотОбъект.ЭтоВстроеннаяОбработка Тогда
		ЭтотОбъект.Плагины = ЭтотОбъект.ПолучитьПлагины();
	Иначе
		КаталогПлагинов = ПолучитьПутьКПлагинам();
		НайденныеФайлы = НайтиФайлы(КаталогПлагинов, "*.epf", Ложь);
		Для каждого ФайлОбработки Из НайденныеФайлы Цикл
			Обработка = ВнешниеОбработки.Создать(ФайлОбработки.ПолноеИмя, Ложь);
			Попытка
				ОписаниеПлагина = Обработка.ОписаниеПлагина(ЭтотОбъект.ТипыПлагинов);
				Обработка.Инициализация(ЭтотОбъект);
				ЭтотОбъект.Плагины.Вставить(ОписаниеПлагина.Идентификатор, Обработка);
			Исключение
				Ошибка = "Возникла ошибка при загрузке плагина: "+ФайлОбработки.Имя + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				Сообщить(Ошибка);
				Продолжить;
			КонецПопытки;
		КонецЦикла;
	КонецЕсли;
	
	ДобавитьКомандыЗагрузчиковНаФорме();
КонецПроцедуры

Процедура КэшироватьПеречисленияПлагинов()
	ЭтотОбъект.ТипыУзловДереваТестов = Плагин("ПостроительДереваТестов").ТипыУзловДереваТестов;
КонецПроцедуры

Процедура ДобавитьКомандыЗагрузчиковНаФорме()
	ОписанияЗагрузчиков = ЭтотОбъект.ПолучитьОписанияПлагиновПоТипу(ЭтотОбъект.ТипыПлагинов.Загрузчик);
	Меню = ЭлементыФормы.КнопкаЗагрузитьТесты.Кнопки;
	
	ИндексКнопки = 0;
	Для каждого ОписаниеПлагина Из ОписанияЗагрузчиков Цикл
		НоваяКнопка = Меню.Вставить(ИндексКнопки, ОписаниеПлагина.Идентификатор, ТипКнопкиКоманднойПанели.Действие, ОписаниеПлагина.Представление, Новый Действие("Подключаемый_ИнтерактивныйВызовЗагрузчика"));
		ИндексКнопки = ИндексКнопки + 1;
	КонецЦикла;
	НоваяКнопка = Меню.Вставить(ИндексКнопки, "", ТипКнопкиКоманднойПанели.Разделитель);
КонецПроцедуры
// } Плагины

// { Работа с деревом тестов
Процедура Подключаемый_ИнтерактивныйВызовЗагрузчика(Кнопка)
	ИдентификаторЗагрузчика = Кнопка.Имя;
	Путь = ЭтотОбъект.Плагин(ИдентификаторЗагрузчика).ВыбратьПутьИнтерактивно(ЭтаФорма);
	Если ЗначениеЗаполнено(Путь) Тогда
		ЗагрузитьТесты(ИдентификаторЗагрузчика, Путь);
	КонецЕсли;
КонецПроцедуры 

Процедура ЗагрузитьТесты(Знач ИдентификаторЗагрузчика, Знач Путь)
	ИнициализироватьИндикаторВыполнения();
	
	ЭтаФорма.Загрузчик = ЭтотОбъект.Плагин(ИдентификаторЗагрузчика);
	
	Попытка
		ЭтаФорма.ДеревоОтЗагрузчика = ЭтаФорма.Загрузчик.Загрузить(ЭтотОбъект, Путь);
	Исключение
		Сообщить(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат;
	КонецПопытки;
	
	ОбновитьИменаИПредставлениеТестов(ДеревоОтЗагрузчика);
	
	ДеревоТестов.Строки.Очистить();
	ЗаполнитьДеревоТестов(ДеревоТестов, ДеревоОтЗагрузчика);
	
	КоличествоТестовыхСлучаев = ЗаполнитьКоличествоТестовыхСлучаевПоВсемуДеревуТестов(ДеревоТестов);
	РазвернутьСтрокиДерева(КоличествоТестовыхСлучаев < 30);
	
	ЭтотОбъект.СохранитьВИсториюЗагрузкиТестов(ИдентификаторЗагрузчика, Путь);
	ОбновитьКнопкиИсторииЗагрузкиТестов();
КонецПроцедуры

Процедура ЗаполнитьДеревоТестов(РодительскаяСтрокаДереваТестов, Знач КонтейнерДереваТестовЗагрузчика)
	СтрокаКонтейнера = РодительскаяСтрокаДереваТестов.Строки.Добавить();
	СтрокаКонтейнера.Имя = КонтейнерДереваТестовЗагрузчика.Имя;
	СтрокаКонтейнера.ИконкаУзла = КонтейнерДереваТестовЗагрузчика.ИконкаУзла;
	СтрокаКонтейнера.Ключ = КонтейнерДереваТестовЗагрузчика.Ключ;
	
	Для каждого ЭлементКоллекции Из КонтейнерДереваТестовЗагрузчика.Строки Цикл
		Если ЭлементКоллекции.Тип = ЭтотОбъект.ТипыУзловДереваТестов.Контейнер Тогда
			ЗаполнитьДеревоТестов(СтрокаКонтейнера, ЭлементКоллекции);
		ИначеЕсли ЭлементКоллекции.Тип = ЭтотОбъект.ТипыУзловДереваТестов.Элемент Тогда
			СтрокаЭлемента = СтрокаКонтейнера.Строки.Добавить();
			СтрокаЭлемента.Имя = ЭлементКоллекции.Представление;
			СтрокаЭлемента.Путь = ЭлементКоллекции.Путь;
			СтрокаЭлемента.ИконкаУзла = ЭлементКоллекции.ИконкаУзла;
			СтрокаЭлемента.Ключ = ЭлементКоллекции.Ключ;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ОбновитьИменаИПредставлениеТестов(Знач КонтейнерДереваТестовЗагрузчика)
	
	НовоеИмя = ПредставлениеТеста(КонтейнерДереваТестовЗагрузчика.Имя);
	КонтейнерДереваТестовЗагрузчика.Имя = НовоеИмя;
	Отладка(СтрШаблон("КонтейнерДереваТестовЗагрузчика.Имя %1, Новое имя %2", КонтейнерДереваТестовЗагрузчика.Имя, НовоеИмя));

	Для каждого ЭлементКоллекции Из КонтейнерДереваТестовЗагрузчика.Строки Цикл
		Если ЭлементКоллекции.Тип = ЭтотОбъект.ТипыУзловДереваТестов.Контейнер Тогда
			ОбновитьИменаИПредставлениеТестов(ЭлементКоллекции);
		ИначеЕсли ЭлементКоллекции.Тип = ЭтотОбъект.ТипыУзловДереваТестов.Элемент Тогда
			НовоеИмя = ПредставлениеТеста(ЭлементКоллекции.Представление);
			ЭлементКоллекции.Представление = НовоеИмя;
			Отладка(СтрШаблон("ЭлементКоллекции.Представление %1, Новое представление %2", ЭлементКоллекции.Представление, НовоеИмя));
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

//&НаКлиенте
Функция ПредставлениеТеста(Знач ПредставлениеТеста)

	ПредставлениеТеста = ПредставлениеТеста;
	Если Настройки.ДобавлятьИмяПользователяВПредставлениеТеста Тогда
		ПредставлениеТеста = СтрШаблон("%1 - <%2>", ПредставлениеТеста, ИмяПользователя());
	КонецЕсли;
	Возврат ПредставлениеТеста;

КонецФункции

Функция ЗаполнитьКоличествоТестовыхСлучаевПоВсемуДеревуТестов(РодительскаяСтрока)
	КоллекцияСтрок = РодительскаяСтрока.Строки;
	Если КоллекцияСтрок.Количество() = 0 Тогда
		Возврат 1;
	КонецЕсли;
	ОбщееКоличествоТестов = 0;
	Для каждого СтрокаДерева из КоллекцияСтрок Цикл
		КоличествоТестовВСтроке = ЗаполнитьКоличествоТестовыхСлучаевПоВсемуДеревуТестов(СтрокаДерева);
		СтрокаДерева.КоличествоТестов = КоличествоТестовВСтроке;
        ОбщееКоличествоТестов = ОбщееКоличествоТестов + КоличествоТестовВСтроке;
	КонецЦикла;
	
	Возврат ОбщееКоличествоТестов;
КонецФункции

Процедура РазвернутьСтрокиДерева(Знач ВключаяПодчиненные = Ложь)
	Для каждого СтрокаДерева из ДеревоТестов.Строки Цикл
		ЭлементыФормы.ДеревоТестов.Развернуть(СтрокаДерева, ВключаяПодчиненные);
	КонецЦикла;
КонецПроцедуры

Процедура ОбновитьДеревоТестовНаОснованииРезультатовТестирования(УзелДереваТестов, Знач РезультатТестирования)
	УзелДереваТестов.Состояние = РезультатТестирования.Состояние;
	УзелДереваТестов.ВремяВыполнения = РезультатТестирования.ВремяВыполнения;
	Если РезультатТестирования.Тип = ЭтотОбъект.ТипыУзловДереваТестов.Контейнер Тогда
		Для каждого ДочернийРезультатТестирования Из РезультатТестирования.Строки Цикл
			ДочернийУзелДереваТестов = УзелДереваТестов.Строки.Найти(Строка(ДочернийРезультатТестирования.Ключ), "Ключ");
			ОбновитьДеревоТестовНаОснованииРезультатовТестирования(ДочернийУзелДереваТестов, ДочернийРезультатТестирования);
		КонецЦикла;
	ИначеЕсли РезультатТестирования.Тип = ЭтотОбъект.ТипыУзловДереваТестов.Элемент Тогда
		Если РезультатТестирования.Свойство("Сообщение") И ЗначениеЗаполнено(РезультатТестирования.Сообщение) Тогда
			Сообщить(РезультатТестирования.Сообщение, СтатусСообщения.ОченьВажное);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
// } Работа с деревом тестов

// { История загрузки тестов
Процедура ОбновитьКнопкиИсторииЗагрузкиТестов()
	Если ЭтотОбъект.Настройки.Свойство("ИсторияЗагрузкиТестов") Тогда
		ИсторияЗагрузкиТестов = ЭтотОбъект.Настройки.ИсторияЗагрузкиТестов;
		МенюИсторияЗагрузкиТестов = ЭтаФорма.ЭлементыФормы.КнопкаЗагрузитьТесты.Кнопки.ИсторияЗагрузкиТестов.Кнопки;
		Для Сч = 0 По ИсторияЗагрузкиТестов.Количество() - 1 Цикл
			ИмяКнопки = "История_" + Сч;
			ЭлементИстории = ИсторияЗагрузкиТестов[Сч];
			ТекстКнопки = ЭлементИстории.ИдентификаторЗагрузчика + ": " + ЭлементИстории.Путь;
			Кнопка = МенюИсторияЗагрузкиТестов.Найти(ИмяКнопки);
			Если Кнопка = Неопределено Тогда
				Кнопка = МенюИсторияЗагрузкиТестов.Добавить(ИмяКнопки, ТипКнопкиКоманднойПанели.Действие, , Новый Действие("Подключаемый_ЗагрузитьТестыИзИстории"));
			КонецЕсли;
			Кнопка.Текст = ТекстКнопки;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Процедура Подключаемый_ЗагрузитьТестыИзИстории(Кнопка)
	ИндексИстории = Число(Сред(Кнопка.Имя, Найти(Кнопка.Имя, "_") + 1));
	ИсторияЗагрузкиТестов = ЭтотОбъект.Настройки.ИсторияЗагрузкиТестов;
	ЭлементИстории = ИсторияЗагрузкиТестов[ИндексИстории];
	ЗагрузитьТесты(ЭлементИстории.ИдентификаторЗагрузчика, ЭлементИстории.Путь);
КонецПроцедуры
// } История загрузки тестов

// { Пакетный запуск
Процедура ВыполнитьПакетныйЗапуск(Знач ПараметрЗапуска)
	Перем РезультатыТестирования;
	
	Попытка

		ПарсерКоманднойСтроки = ЭтотОбъект.Плагин("ПарсерКоманднойСтроки");
		ПараметрыЗапуска = ПарсерКоманднойСтроки.Разобрать(ПараметрЗапуска);
		
		ВозможныеКлючи = ПарсерКоманднойСтроки.ВозможныеКлючи;
		
		Если ПараметрыЗапуска.Свойство(ВозможныеКлючи.debug) Тогда
			ФлагОтладки = Истина;
		КонецЕсли;

		ПлагинНастройки = Плагин("Настройки");
		
		Если ФлагОтладки Тогда
			Отладка("");
			Отладка("ПараметрЗапуска <" + ПараметрЗапуска + ">");
			Отладка("");
			Отладка("Переданные параметры:");
			ПлагинНастройки.ПоказатьСвойстваВРежимеОтладки(ПараметрыЗапуска);
			Отладка("");
		КонецЕсли;	
		
		ПлагинНастройки.ДобавитьНастройки(ПараметрыЗапуска);
		
		НастройкиИзПлагина = ПлагинНастройки.ПолучитьНастройки();
		Для каждого КлючЗначение Из НастройкиИзПлагина Цикл
			Настройки.Вставить(КлючЗначение.Ключ, КлючЗначение.Ключ);	
		КонецЦикла;

		Параметры_xddConfig = Неопределено;
		Если ПараметрыЗапуска.Свойство(ВозможныеКлючи.xddConfig, Параметры_xddConfig) Тогда
			ПутьФайлаНастроек = Параметры_xddConfig[0];
		КонецЕсли;

		Параметры_КаталогПроекта = Неопределено;
		Если ПараметрыЗапуска.Свойство(ВозможныеКлючи.workspaceRoot, Параметры_КаталогПроекта) Тогда
			КаталогПроекта = Параметры_КаталогПроекта[0];
		КонецЕсли;

		Параметры_xddRun = Неопределено;
		Если ПараметрыЗапуска.Свойство(ВозможныеКлючи.xddRun, Параметры_xddRun) Тогда
			РезультатыТестирования = ЗагрузитьИВыполнитьТесты_ПакетныйРежим(Параметры_xddRun);
			Если РезультатыТестирования = Неопределено Тогда
				ВывестиСообщение("Не найдено результатов тестирования");
			КонецЕсли; 
		КонецЕсли;
		
		Параметры_xddReport = Неопределено;
		Если ЗначениеЗаполнено(РезультатыТестирования) И ПараметрыЗапуска.Свойство(ВозможныеКлючи.xddReport, Параметры_xddReport) Тогда
			СформироватьОтчетОТестированииИЭкспортировать_ПакетныйРежим(Параметры_xddReport, РезультатыТестирования);
		КонецЕсли;
		
		Параметры_xddExitCodePath = Неопределено;
		Если ПараметрыЗапуска.Свойство(ВозможныеКлючи.xddExitCodePath, Параметры_xddExitCodePath) Тогда
			СформироватьФайлКодаВозврата(Параметры_xddExitCodePath, РезультатыТестирования);
		КонецЕсли;
		
		Если ПараметрыЗапуска.Свойство(ВозможныеКлючи.xddShutdown) Тогда
			ЗавершитьРаботуСистемы(Ложь);
		КонецЕсли;
		
	Исключение
		Инфо = ИнформацияОбОшибке();
		ОписаниеОшибки = "Ошибка загрузки и выполнения тестов в пакетном режиме
		|" + ПодробноеПредставлениеОшибки(Инфо);
		
		ЗафиксироватьОшибкуВЖурналеРегистрации("ПакетныйРежим", ОписаниеОшибки);
		
		ВывестиСообщение(ОписаниеОшибки, СтатусСообщения.ОченьВажное);
		
		ЗавершитьРаботуСистемы(Ложь);
	КонецПопытки;
	
КонецПроцедуры

Функция ЗагрузитьИВыполнитьТесты_ПакетныйРежим(Знач Параметры_xddRun)
		
	ПервичнаяНастройка();
	
	ИдентификаторЗагрузчика = Параметры_xddRun[0];
	Загрузчик = ЭтотОбъект.Плагин(ИдентификаторЗагрузчика);
	
	ПутьКТестам = Параметры_xddRun[1];
	ДеревоТестовОтЗагрузчика = Загрузчик.Загрузить(ЭтотОбъект, ПутьКТестам);
	
	Если ЗначениеЗаполнено(ДеревоТестовОтЗагрузчика.Строки) Тогда
		ОбновитьИменаИПредставлениеТестов(ДеревоТестовОтЗагрузчика);
		
		РезультатыТестирования = ЭтотОбъект.ВыполнитьТесты(Загрузчик, ДеревоТестовОтЗагрузчика);
	Иначе
		
		ВывестиСообщение("Не найдено загруженных тестов. Выполнение тестов завершается");
		
	КонецЕсли;
	
	Возврат РезультатыТестирования;
КонецФункции

Процедура СформироватьОтчетОТестированииИЭкспортировать_ПакетныйРежим(Знач Параметры_xddReport, Знач РезультатыТестирования)
	Если Параметры_xddReport.Количество() > 0 И ТипЗнч(Параметры_xddReport[0]) <> Тип("ФиксированныйМассив") Тогда 
		НовыйМассивПараметров = Новый Массив;
		НовыйМассивПараметров.Добавить(Параметры_xddReport);
		Параметры_xddReport = НовыйМассивПараметров;
	КонецЕсли;
	Для Каждого ОчередныеПараметры Из Параметры_xddReport Цикл
		Попытка
			ИдентификаторГенератораОтчета = ОчередныеПараметры[0];
			ГенераторОтчета = ЭтотОбъект.Плагин(ИдентификаторГенератораОтчета);
			
			НаборОтчетов = ГенераторОтчета.СоздатьОтчет(ЭтаФорма, РезультатыТестирования);
			Если ТипЗнч(НаборОтчетов) <> Тип("Массив") Тогда
				НовыйНаборОтчетов = Новый Массив;
				НовыйНаборОтчетов.Добавить(НаборОтчетов);
				НаборОтчетов = НовыйНаборОтчетов;
			КонецЕсли; 
			
			ПутьКОтчету = ОчередныеПараметры[1];

			ОписаниеОшибки = СтрШаблон_("ОФ ПутьКОтчету %1", ПутьКОтчету);
			ЗафиксироватьОшибкуВЖурналеРегистрации(ИдентификаторГенератораОтчета, ОписаниеОшибки, Истина);

			Для Каждого Отчет Из НаборОтчетов Цикл
				ГенераторОтчета.Экспортировать(Отчет, ПутьКОтчету);
			КонецЦикла; 
		Исключение
			Инфо = ИнформацияОбОшибке();
			ОписаниеОшибки = "Ошибка формирования и экспорта отчета о тестировании в пакетном режиме
			|" + ПодробноеПредставлениеОшибки(Инфо);
			
			ЗафиксироватьОшибкуВЖурналеРегистрации(ИдентификаторГенератораОтчета, ОписаниеОшибки);
			ВывестиСообщение(ОписаниеОшибки, СтатусСообщения.ОченьВажное);
		КонецПопытки;
	КонецЦикла;
КонецПроцедуры

Процедура СформироватьФайлКодаВозврата(Знач Параметры_xddExitCodePath, Знач РезультатыТестирования)
	Попытка
		ИдентификаторПлагина = Параметры_xddExitCodePath[0];
		ГенераторКодаВозврата = ЭтотОбъект.Плагин(ИдентификаторПлагина);
		
		ПутьФайлаКодаВозврата = Параметры_xddExitCodePath[1];
		ГенераторКодаВозврата.СформироватьФайл(ЭтотОбъект, ПутьФайлаКодаВозврата, РезультатыТестирования);
	Исключение
		Инфо = ИнформацияОбОшибке();
		ОписаниеОшибки = "Ошибка формирования файла статуса возврата при выполнении тестов в пакетном режиме
		|" + ПодробноеПредставлениеОшибки(Инфо);
		
		ЗафиксироватьОшибкуВЖурналеРегистрации("ПакетныйРежим", ОписаниеОшибки);
		ВывестиСообщение(ОписаниеОшибки, СтатусСообщения.ОченьВажное);
	КонецПопытки;
КонецПроцедуры

// } Пакетный запуск

// { Внешние интерфейсные инструменты
Процедура ОткрытьИнструмент(Знач ИмяИнструмента, Знач ПутьИнструмента = "", Знач ИмяФормы = "Форма")
	// Если браузер тестов встроен в конфигурацию, то обработки инструментов
	// получаем также из состава конфигурации
	Если ЭтотОбъект.ЭтоВстроеннаяОбработка Тогда
		// Преобразование имени инструмента к имени обработки
		Если ИмяИнструмента = "UILogToScript" Тогда
			ИмяИнструмента = "ПреобразованиеЖурналаДействийПользователя";
		КонецЕсли;
		НоваяФорма = ПолучитьФорму("Обработка." + ИмяИнструмента + "." + ИмяФормы);	
	Иначе
		Если Не ПустаяСтрока(ПутьИнструмента) Тогда
			ПутьКВнешнимИнструментам = ПутьИнструмента + "\";
		Иначе
			ПутьКВнешнимИнструментам = ПолучитьПутьКВнешнимИнструментам();
		КонецЕсли;
		ПутьИнструмента = ПутьКВнешнимИнструментам + ИмяИнструмента + ".epf";
		ФайлИнструмента = Новый Файл(ПутьИнструмента);
		Если Не ФайлИнструмента.Существует() Тогда
			Сообщить("Инструмент <" + ИмяИнструмента + "> не найден в каталоге <" + ФайлИнструмента.Путь + ">");
			Возврат;
		КонецЕсли;
		Обработка = ВнешниеОбработки.Создать(ФайлИнструмента.ПолноеИмя, Ложь);
		НоваяФорма = Обработка.ПолучитьФорму(ИмяФормы);
		Если НоваяФорма = Неопределено Тогда
			Сообщить("Инструмент <" + ИмяИнструмента + ">: не удалось получить основную форму!");
			Возврат;
		КонецЕсли;
	КонецЕсли;
	НоваяФорма.Открыть();
	НоваяФорма = Неопределено;
КонецПроцедуры

Функция ПолучитьПутьКПлагинам()
	// Для встроенной в состав конфигурации обработки
	// имя используемого файла не получаем, т.к. плагины 
	// получаются из встроенной подсистемы
	Если НЕ ЭтотОбъект.ЭтоВстроеннаяОбработка Тогда
		ФайлЯдра = Новый Файл(ЭтаФорма["ИспользуемоеИмяФайла"]);
		Результат = ФайлЯдра.Путь + "Plugins\";
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция ПолучитьПутьКВнешнимИнструментам()
	ФайлЯдра = Новый Файл(ЭтотОбъект.ИспользуемоеИмяФайла);
	Результат = ФайлЯдра.Путь + "tools\epf\utils\";
	
	Возврат Результат;
КонецФункции
// } Внешние интерфейстные инструменты

// Замена функции СтрШаблон на конфигурациях с режимом совместимости < 8.3.6
// При внедрении в конфигурацию с режимом совместимости >= 8.3.6 данную функцию необходимо удалить
//
//&НаКлиентеНаСервереБезКонтекста
Функция СтрШаблон_(Знач СтрокаШаблон, Знач Парам1 = Неопределено, Знач Парам2 = Неопределено, Знач Парам3 = Неопределено, Знач Парам4 = Неопределено, Знач Парам5 = Неопределено) Экспорт
		
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Парам1);
	МассивПараметров.Добавить(Парам2);
	МассивПараметров.Добавить(Парам3);
	МассивПараметров.Добавить(Парам4);
	МассивПараметров.Добавить(Парам5);
	
	Для Сч = 1 По МассивПараметров.Количество() Цикл
		ТекЗначение = МассивПараметров[Сч-1];
		СтрокаШаблон = СтрЗаменить(СтрокаШаблон, "%"+Сч, Строка(ТекЗначение));
	КонецЦикла;
	Возврат СтрокаШаблон;
КонецФункции

Процедура ИнициализироватьИндикаторВыполнения(Знач КоличествоТестовыхМетодов = 0)
	ЭлементыФормы.ИндикаторВыполнения.МаксимальноеЗначение = КоличествоТестовыхМетодов;
	ЭлементыФормы.ИндикаторВыполнения.Значение = 0;
	ЭлементыФормы.ИндикаторВыполнения.ЦветРамки = Новый Цвет(0, 174, 0); // Зеленый
КонецПроцедуры

// { работа с настройками

Процедура ЗагрузитьНастройкиИзФайлаЗавершение(ВыбранныеФайлы, ДопПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено или ВыбранныеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли; 
	
	ФайлНастройки = ВыбранныеФайлы.Получить(0);
	ПутьФайлаНастроек = ФайлНастройки;

	ПлагинНастроек = Плагин("Настройки");
	ПлагинНастроек.Обновить();
	
КонецПроцедуры

Процедура ПерезагрузитьНастройкиИзФайла()
	
	Если Не ПустаяСтрока(ПутьФайлаНастроек()) Тогда		
		
		Попытка
			ПервичнаяНастройка();
			//Плагин("Настройки").Обновить();
		Исключение
			Сообщить("Не удалось загрузить настройки из файла '" + ПутьФайлаНастроек() + "' по причине: ");
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПервичнаяНастройка()
	
	Перем ПлагинВыводВЛогФайл, ПлагинНастроек;
	
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Настройки = Новый Структура;
	КонецЕсли;
	
	НаборНастроекПоУмолчанию = СоздатьНаборНастроекПоУмолчанию();
	ЗаменитьНесуществующиеНастройкиЗначениямиПоУмолчанию(Настройки, НаборНастроекПоУмолчанию);
	
	ПлагинНастроек = Плагин("Настройки");
	ПлагинНастроек.Обновить();
	
	Для Каждого КлючЗначение Из ПлагинНастроек.ПолучитьНастройки() Цикл
		Настройки.Вставить(КлючЗначение.Ключ, КлючЗначение.Значение);
	КонецЦикла;
	
	ФлагОтладки = ПлагинНастроек.ПолучитьНастройку("Отладка") = Истина;
	
	ВыводитьЛогВыполненияСценариевВТекстовыйФайл = Ложь;
	Если ПлагинНастроек.ЕстьНастройка("ДелатьЛогВыполненияСценариевВТекстовыйФайл") Тогда
		ВыводитьЛогВыполненияСценариевВТекстовыйФайл = Настройки.ДелатьЛогВыполненияСценариевВТекстовыйФайл;
	КонецЕсли;
	ИмяФайлаЛогВыполненияСценариев = "";
	Если ПлагинНастроек.ЕстьНастройка("ИмяФайлаЛогВыполненияСценариев") Тогда
		ИмяФайлаЛогВыполненияСценариев = Настройки.ИмяФайлаЛогВыполненияСценариев;
		//Иначе 
		//	ИмяФайлаЛогВыполненияСценариев = ПолучитьИмяВременногоФайла(".log");
	КонецЕсли;
	
	Если ВыводитьЛогВыполненияСценариевВТекстовыйФайл Тогда
		
		ПлагинВыводВЛогФайл = Плагин("ВыводВЛогФайл");
		
		ПлагинВыводВЛогФайл.ОткрытьФайл(ИмяФайлаЛогВыполненияСценариев);
	КонецЕсли;
	
	Отладка(СтрШаблон_("ВыводитьЛогВыполненияСценариевВТекстовыйФайл <%1>", ВыводитьЛогВыполненияСценариевВТекстовыйФайл));
	Отладка(СтрШаблон_("ИмяФайлаЛогВыполненияСценариев <%1>", ИмяФайлаЛогВыполненияСценариев));

КонецПроцедуры

Функция СоздатьНаборНастроекПоУмолчанию()

	Рез = Новый Структура;
	
	Рез.Вставить("Отладка", Ложь);
	Рез.Вставить("ДелатьЛогВыполненияСценариевВТекстовыйФайл", Ложь);
	Рез.Вставить("ИмяФайлаЛогВыполненияСценариев", "");
	Рез.Вставить("ДобавлятьИмяПользователяВПредставлениеТеста", Ложь);
	
	Возврат Новый ФиксированнаяСтруктура(Рез);

КонецФункции // ()

Процедура ЗаменитьНесуществующиеНастройкиЗначениямиПоУмолчанию(Знач Настройки, Знач НаборНастроекПоУмолчанию)
	
	Для каждого КлючЗначение Из НаборНастроекПоУмолчанию Цикл
		Если Не Настройки.Свойство(КлючЗначение.Ключ) Тогда
			Настройки.Вставить(КлючЗначение.Ключ, КлючЗначение.Значение);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

// } работа с настройками
