Table places {
  id varchar(6) [primary key]
  name varchar [null]
  parent_id varchar(4) [null, note: "NULL - место 1го уровня"]
  photo_id uuid [null, note: "Межсервисная ссылка без FK, см. README → Межсервисные ссылки"]
  posts_count bigint [not null, default: 0, note: "Количество постов"]
  place_rating_amount bigint [not null, default: 0, note: "Количество оценок"]
  place_rating_sum bigint [not null, default: 0, note: "Сумма оценок"]
  
  indexes {
    (parent_id, posts_count, id)
  }
}

Table places_posts {
  post_id uuid [primary key, note: "Межсервисная ссылка без FK, см. README → Межсервисные ссылки"]
  place_id varchar(6) [not null, note: "Связь с places"]
  rating_amount int [not null, default: 0, note: "Количество оценок"]
  rating_sum int [not null, default: 0, note: "Сумма оценок"]
}

Ref: "places"."id" <? "places_posts"."place_id"