# cld-homework-2

## Задание 1

Для выполнения задания в каталоге [src](https://github.com/RiteHist/cld-homework-2/blob/main/src/) были созданы следующие файлы:

- [bucket.tf](https://github.com/RiteHist/cld-homework-2/blob/main/src/bucket.tf) - в данном файле описано создание бакета и загрузка в него изображения
- [lamp.tf](https://github.com/RiteHist/cld-homework-2/blob/main/src/lamp.tf) - в данном файле описано создание группы ВМ с шаблоном LAMP и сетевого балансировщика
- [cloud-init.tftpl](https://github.com/RiteHist/cld-homework-2/blob/main/src/cloud-init.tftpl) - в данный файл добавлено создание html страницы со ссылкой на изображение из бакета

На скриншоте видно, что после отработки `terraform apply` сетевой балансировщик был успешно создан и привязан к группе ВМ:

![alt text](https://github.com/ritehist/cld-homework-2/blob/main/media/1.PNG?raw=true)

На данном скриншоте видно, что по адресу балансировщика успешно открывается html страница с изображением из бакета:

![alt text](https://github.com/ritehist/cld-homework-2/blob/main/media/2.PNG?raw=true)

При удалении одной ВМ из группы можно видеть, что две другие ВМ остались привязаны к балансировщику:

![alt text](https://github.com/ritehist/cld-homework-2/blob/main/media/3.PNG?raw=true)
