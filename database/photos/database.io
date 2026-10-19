Table photos_temp {
  id uuid [primary key]
  created_at timestamp [not null]
  transferred_at timestamp [null, note: 'NULL — ещё не перенесено в photos']
  author_id uuid [not null]
  host varchar [not null]
  path varchar [not null]

  indexes {
    created_at
  } 
}

Table photos {
  id uuid [primary key]
  post_id uuid [not null, note: "Межсервисная ссылка без FK, см. README → Межсервисные ссылки"]
  preview bool [not null, default: false]
  host varchar [not null, note: "photo_url - host + path"]
  path varchar [not null, note: "photo_url - host + path"]
  Note: 'У обложки preview = true'

  indexes {
    (post_id, preview)
  } 
}