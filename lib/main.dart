// ЛР 1 — шесть независимых виджетов.
//
// Как сдавать: скопируйте этот файл целиком себе в main.dart, допишите
// шесть функций ниже вместо TODO, запустите — все шесть элементов должны
// появиться на экране. Пришлите готовый файл на проверку.
//
// Основной виджет трогать не нужно. Редактируйте там, где написано TODO.

import 'package:flutter/material.dart';

void main() {
  runApp(const Lab1App());
}

class Lab1App extends StatelessWidget {
  const Lab1App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ЛР 1')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Task 1:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              task1(),
              const SizedBox(height: 4),
              Divider(),
              const SizedBox(height: 4),
              Text(
                'Task 2:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              task2(),

              const SizedBox(height: 4),
              Divider(),
              const SizedBox(height: 4),
              Text(
                'Task 3:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              task3(),
              const SizedBox(height: 4),
              Divider(),
              const SizedBox(height: 4),
              Text(
                'Task 4:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              task4(),
              const SizedBox(height: 4),
              Divider(),
              const SizedBox(height: 4),
              Text(
                'Task 5:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              task5(),
              const SizedBox(height: 4),
              Divider(),
              const SizedBox(height: 4),
              Text(
                'Task 6:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              task6(),
            ],
          ),
        ),
      ),
    );
  }
}

// 1. Заголовок — Text, крупный жирный текст чёрного цвета, обрезается в одну строку, если не помещается.
Widget task1() {
  return const Text(
    'Оставлен за спиной, возраст Христа, Обратной стороной повернулась мечта',
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  );
}
// 2. Подпись — небольшой, нежирный курсивный текст белого цвета, обрезается в две строки.
// Также реализуйте подложку из тёмно-серого контейнера с закруглениями, чтобы текст было видно
Widget task2() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.grey[600],
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Text(
      'Моя милая девочка Саша, сердцеедка со стажем, как и я прямо скажем, но мы прямо ничего друг другу не скажем',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        color: Colors.white,
      ),
    ),
  );
}

// 3. Иконка — любая Icon на ваш вкус,
// с применением цвета и размером.
Widget task3() {
  return const Icon(
    Icons.star_outlined,
    color: Color.fromARGB(255, 253, 196, 24),
    size: 24,
  );
}

// 4. Кнопка с иконкой избранного — большая иконка сердца красного цвета без фона.
// При нажатии пишет в консоль "Вы добавили в избранное"
Widget task4() {
  return IconButton(
    iconSize: 72,
    icon: const Icon(
      Icons.push_pin_rounded,
      color: Colors.red,
    ),
    onPressed: () {
      debugPrint('Вы добавили в збранное');
    },
  );
}

// 5. Кнопка «Подробнее» — кнопка с текстом и обводкой, при нажатии пишет в консоль "Узнать детали"
Widget task5() {
  return OutlinedButton(
    onPressed: () {
      debugPrint('Узнать детали');
    },
    child: const Text('Подробнее'),
  );
}

// 6. Изображение в стиле Polaroid—  выберите любое из каталога по ссылке
// https://picsum.photos/ (необходим vpn), либо используйте https://docs.flutter.dev/assets/images/dash/dash-fainting.gif
// Добавьте чёрную обводку, а внутри белую рамку в стиле фотографии Polaroid (https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAeKRHzUEOMCX836O6p8R5-XBkrSlf8C4go4C7f1q8ClnmlFaV9emSrUFL&s=10)
// Для реализации используйте Container
Widget task6() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.black, width: 2),
    ),
    padding: const EdgeInsets.fromLTRB(12, 12, 12, 48),
    child: Image.network(
      'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
      width: 250,
      height: 200,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 250,
          height: 200,
          color: Colors.grey[300],
          alignment: Alignment.center,
          child: const Text('Не удалось загрузить фото'),
        );
      },
    ),
  );
}