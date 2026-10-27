// Replication: master-slave, асинхронная, RF 3 (1 ведущий + 2 ведомых); чтение — с ведомых
// Sharding: нет, 1 шард — 438 ГБ, 1 NVMe на хост
// Hosts: 3 — README → Распределённое хранение данных → Оценка хостов

Table posts {
  id uuid [primary key]
  created_at timestamp [not null]
  text text [not null, note: 'Текст поста']
  author_id uuid [not null]
  place_id varchar(6) [not null, note: "Связь с местами"]
  parent_place_id varchar(4) [not null, note: "Место родитель - 4 символа"]
  latitude double [not null, note: "Широта"]
  longitude double [not null, note: "Долгота"]
  rating_amount int [not null, default: 0, note: "Количество оценок"]
  rating_sum int [not null, default: 0, note: "Сумма оценок"]
  Note: "id UUIDv7, сгенерированный при создании поста - содержит метку времени"

  indexes {
    (place_id, id)
    (parent_place_id, id)
    (author_id, id)
  }
}

Table posts_photos {
  post_id uuid [not null, note: "Связь с posts"]
  photo_id uuid [not null, note: "Межсервисная ссылка без FK. ID фото из photo_uploads или photos (при переносе сохраняется). Существование и владелец проверяются синхронным запросом в фото-сервис при создании поста."]
  sort int [not null, note: "Порядок фото"]
  Note: 'Порядок привязанных к посту фото'

  indexes {
    (post_id, sort) [pk]
    photo_id [unique]
  }
}

Table posts_outbox {
  id uuid [primary key, note: 'UUIDv7, ключ идемпотентности для потребителей']
  created_at timestamp [not null]
  event_type varchar [not null, note: 'POST_CREATED']
  post_id uuid [not null, note: 'Ключ партиции в Kafka. Пишется в одной транзакции с постом, FK не нужен']
  payload jsonb [not null, note: 'POST_CREATED: photo_ids (в порядке карусели), place_id, author_id']
  Note: 'Строка вставляется и удаляется в одной транзакции; событие публикует CDC из WAL. Таблица всегда пуста.'
}

Ref: "posts_photos"."post_id" ?> "posts"."id"