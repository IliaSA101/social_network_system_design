// Replication: master-slave, асинхронная, RF 3 (1 ведущий + 2 ведомых); чтение — с ведомых
// Sharding: нет, 1 шард — 3,2 ГБ, 1 NVMe на хост
// Hosts: 3 — README → Распределённое хранение данных → Оценка хостов

Table users {
  id uuid [primary key]
  name varchar [not null, note: "Имя пользователя"]
}