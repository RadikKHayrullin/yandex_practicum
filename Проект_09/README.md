# Приоритизация гипотез и анализ A/B-теста для увеличения выручки интернет-магазина  

## Описание проекта  
В крупном интернет-магазине совместно с отделом маркетинга был составлен список гипотез, направленных на увеличение выручки. Однако ресурсы на тестирование ограничены, поэтому важно выбрать наиболее перспективные гипотезы и проверить их эффективность с помощью A/B-тестирования.  

На основе данных о гипотезах и результатах A/B-теста необходимо:  
- Приоритизировать гипотезы для дальнейшего тестирования.  
- Проанализировать результаты A/B-теста и определить, привела ли выбранная гипотеза к значимому увеличению выручки.  

## Гипотезы  
1. **Гипотезы различаются по охвату и влиянию**:  
   - Некоторые гипотезы могут охватывать больше пользователей, но иметь меньшее влияние на выручку.  
   - Другие гипотезы могут быть более узконаправленными, но оказывать значительное влияние на ключевые метрики.  
2. **Результаты A/B-теста покажут значимость изменений**:  
   - Если гипотеза эффективна, то группа с изменениями покажет статистически значимый рост выручки.  
   - Если различия между группами незначимы, гипотеза не принесла ожидаемого эффекта.  

## Описание данных  
Данные разделены на две части:  

### Данные для приоритизации гипотез  
Файл: `hypothesis.csv`  

| Колонка      | Описание                                                                 |
|--------------|-------------------------------------------------------------------------|
| `Hypothesis` | Краткое описание гипотезы                                               |
| `Reach`      | Охват пользователей по 10-балльной шкале                                |
| `Impact`     | Влияние на пользователей по 10-балльной шкале                           |
| `Confidence` | Уверенность в гипотезе по 10-балльной шкале                            |
| `Efforts`    | Затраты ресурсов на проверку гипотезы по 10-балльной шкале              |

### Данные для анализа A/B-теста  
Файл: `orders.csv`  

| Колонка         | Описание                                                                 |
|-----------------|-------------------------------------------------------------------------|
| `transactionId` | Идентификатор заказа                                                    |
| `visitorId`     | Идентификатор пользователя, совершившего заказ                          |
| `date`          | Дата совершения заказа                                                  |
| `revenue`       | Выручка заказа                                                          |
| `group`         | Группа A/B-теста (A — контрольная, B — тестовая)                        |

Файл: `visitors.csv`  

| Колонка      | Описание                                                                 |
|--------------|-------------------------------------------------------------------------|
| `date`       | Дата                                                                    |
| `group`      | Группа A/B-теста (A — контрольная, B — тестовая)                        |
| `visitors`   | Количество пользователей в указанную дату в указанной группе A/B-теста  |

## Статус проекта  
**Завершён** ✅  
