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