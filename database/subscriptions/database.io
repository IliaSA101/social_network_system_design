Table subscribers {
  subscriber_id uuid [not null, note: 'Межсервисная ссылка без FK. Пользователь из токена.']
  author_id uuid [not null, note: 'Межсервисная ссылка без FK. Существование автора проверяется синхронным запросом в сервис пользователей при PUT; нет пользователя — 404.']

  indexes {
    (author_id, subscriber_id) [pk]
  }

  checks {
    `subscriber_id <> author_id` [name: 'chk_no_self_subscription']
  }
}