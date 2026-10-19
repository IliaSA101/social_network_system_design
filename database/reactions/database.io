Table reactions {
  post_id uuid [not null, note: "Межсервисная ссылка без FK. Существование поста проверяется синхронным запросом в сервис постов при PUT; нет поста — 404."]
  author_id uuid [not null, note: "Автор оценки"]
  updated_at timestamp [not null, note: "Дата последнего обновления/добавления"]
  value smallint [not null, note: "Значение оценки"]
  
  indexes {
    (post_id, author_id) [pk]
    updated_at
  }
}

Table reactions_outbox {
  id uuid [primary key, note: 'UUIDv7, ключ идемпотентности для потребителей']
  created_at timestamp [not null]
  event_type varchar [not null, note: 'REACTION_SET, POST_REACTIONS_SNAPSHOT']
  post_id uuid [not null, note: 'Пост, к которому относится событие. Ключ партиции в Kafka. Пишется в одной транзакции с оценкой или снимком, FK не нужен']
  payload jsonb [not null, note: 'REACTION_SET: old_value (null у первой оценки), new_value. POST_REACTIONS_SNAPSHOT: amount, sum — полный агрегат оценок поста']
  Note: 'Строка вставляется и удаляется в одной транзакции; событие публикует CDC из WAL. Таблица всегда пуста. Снимки пишет суточный воркер пересчёта по постам с изменёнными оценками.'
}