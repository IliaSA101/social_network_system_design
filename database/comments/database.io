// Replication: master-slave, асинхронная, RF 3 (1 ведущий + 2 ведомых); чтение — с ведомых
// Sharding: нет, 1 шард — 4,3 ТБ, 1 NVMe на хост
// Hosts: 3 — README → Распределённое хранение данных → Оценка хостов

Table comments {
  id uuid [primary key]
  created_at timestamp [not null, note: "Дата комментария"]
  text varchar(500) [not null, note: "Текст комментария"]
  post_id uuid [not null, note: "Межсервисная ссылка без FK. Существование поста проверяется синхронным запросом в сервис постов при POST; нет поста — 404."]
  author_id uuid [not null, note: "Межсервисная ссылка без FK. Пользователь из токена."]

  indexes {
    (post_id, created_at, id)
  }
}