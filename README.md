# VK-iOS-intern-MNK

Приложение "Крестики-Нолики" с произвольным размером поля. Более подробно: [MNK](https://en.wikipedia.org/wiki/M,n,k-game)

#### Приложение поддерживает выбор игрового поля:
- [x] M - высота доски
- [x] N - ширина доски
- [x] K - число клеток, которое необходимо закрыть для выигрыша

#### Приложение поддерживает несколько режимов игры:
- [x] вдвоем
- [x] с компьютером

На экране игры, можно начать раунд заново, обнулиться счет или вернуться назад.

#### Основные детали реализации.
Пакет Game содержит основную логику игры. Код не зависит от деталей iOS разработки и может использоваться в другом месте.

Взаимодейсвие модулей в приложение происходит по технологии MVC. Два контроллера обмениваются и хранят модель. Для отображения UI части контроллеры создают View. Модель содержит экземпляр доски и игроков из пакеты Game, а также необходимые конфигурации.

## Фотографии для демонстрации работы приложения
![](https://github.com/gr-rassadnikov/VK-iOS-intern-MNK/blob/main/images/photo_2023-05-10%2022.57.37.jpeg)

![](https://github.com/gr-rassadnikov/VK-iOS-intern-MNK/blob/main/images/photo_2023-05-10%2022.57.40.jpeg)

![](https://github.com/gr-rassadnikov/VK-iOS-intern-MNK/blob/main/images/photo_2023-05-10%2022.57.41.jpeg)

![](https://github.com/gr-rassadnikov/VK-iOS-intern-MNK/blob/main/images/photo_2023-05-10%2022.57.43.jpeg)

![](https://github.com/gr-rassadnikov/VK-iOS-intern-MNK/blob/main/images/photo_2023-05-10%2022.57.44.jpeg)

![](https://github.com/gr-rassadnikov/VK-iOS-intern-MNK/blob/main/images/photo_2023-05-10%2022.57.45.jpeg)

![](https://github.com/gr-rassadnikov/VK-iOS-intern-MNK/blob/main/images/photo_2023-05-10%2022.57.47.jpeg)

![](https://github.com/gr-rassadnikov/VK-iOS-intern-MNK/blob/main/images/photo_2023-05-10%2022.57.48.jpeg)
 
