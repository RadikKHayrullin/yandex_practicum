# Исследование объявлений о продаже квартир

## Описание проекта  
Вы получили доступ к данным сервиса **Яндекс Недвижимость** — архиву объявлений о продаже квартир в Санкт-Петербурге и ближайших населённых пунктах за несколько лет. Ваша задача — проанализировать данные и выявить факторы, влияющие на рыночную стоимость недвижимости.  

Результаты исследования помогут в разработке автоматизированной системы, которая позволит выявлять аномалии и случаи мошенничества в объявлениях.

## Описание данных  
В предоставленном наборе содержатся два типа данных: введённые пользователем и автоматически полученные с помощью картографических сервисов. Например, информация о расстоянии до центра города, ближайшего аэропорта, количества парков и водоёмов в радиусе 3 км.

### Основные параметры данных:

| Колонка             | Описание |
|---------------------|----------|
| `airports_nearest` | Расстояние до ближайшего аэропорта (м) |
| `balcony`         | Число балконов |
| `ceiling_height`  | Высота потолков (м) |
| `cityCenters_nearest` | Расстояние до центра города (м) |
| `days_exposition` | Количество дней публикации объявления |
| `first_day_exposition` | Дата публикации объявления |
| `floor`          | Этаж |
| `floors_total`   | Общее количество этажей в доме |
| `is_apartment`   | Является ли жильё апартаментами (булев тип) |
| `kitchen_area`   | Площадь кухни (м²) |
| `last_price`     | Цена на момент снятия с публикации |
| `living_area`    | Жилая площадь (м²) |
| `locality_name`  | Название населённого пункта |
| `open_plan`      | Свободная планировка (булев тип) |
| `parks_around3000` | Число парков в радиусе 3 км |
| `parks_nearest`  | Расстояние до ближайшего парка (м) |
| `ponds_around3000` | Число водоёмов в радиусе 3 км |
| `ponds_nearest`  | Расстояние до ближайшего водоёма (м) |
| `rooms`          | Количество комнат |
| `studio`         | Квартира-студия (булев тип) |
| `total_area`     | Общая площадь квартиры (м²) |
| `total_images`   | Число фотографий в объявлении |

## Статус проекта  
**Завершён** ✅
