create table dealer (
    id integer primary key ,
    name varchar(255),
    location varchar(255),
    charge float
);

INSERT INTO dealer (id, name, location, charge) VALUES (101, 'Ерлан', 'Алматы', 0.15);
INSERT INTO dealer (id, name, location, charge) VALUES (102, 'Жасмин', 'Караганда', 0.13);
INSERT INTO dealer (id, name, location, charge) VALUES (105, 'Азамат', 'Нур-Султан', 0.11);
INSERT INTO dealer (id, name, location, charge) VALUES (106, 'Канат', 'Караганда', 0.14);
INSERT INTO dealer (id, name, location, charge) VALUES (107, 'Евгений', 'Атырау', 0.13);
INSERT INTO dealer (id, name, location, charge) VALUES (103, 'Жулдыз', 'Актобе', 0.12);

create table client (
    id integer primary key ,
    name varchar(255),
    city varchar(255),
    priority integer,
    dealer_id integer references dealer(id)
);

INSERT INTO client (id, name, city, priority, dealer_id) VALUES (802, 'Айша', 'Алматы', 100, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (807, 'Даулет', 'Алматы', 200, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (805, 'Али', 'Кокшетау', 200, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (808, 'Ильяс', 'Нур-Султан', 300, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (804, 'Алия', 'Караганда', 300, 106);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (809, 'Саша', 'Шымкент', 100, 103);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (803, 'Маша', 'Семей', 200, 107);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (801, 'Максат', 'Нур-Султан', null, 105);

create table sell (
    id integer primary key,
    amount float,
    date timestamp,
    client_id integer references client(id),
    dealer_id integer references dealer(id)
);

INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (201, 150.5, '2012-10-05 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (209, 270.65, '2012-09-10 00:00:00.000000', 801, 105);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (202, 65.26, '2012-10-05 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (204, 110.5, '2012-08-17 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (207, 948.5, '2012-09-10 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (205, 2400.6, '2012-07-27 00:00:00.000000', 807, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (208, 5760, '2012-09-10 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (210, 1983.43, '2012-10-10 00:00:00.000000', 804, 106);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (203, 2480.4, '2012-10-10 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (212, 250.45, '2012-06-27 00:00:00.000000', 808, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (211, 75.29, '2012-08-17 00:00:00.000000', 803, 107);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (213, 3045.6, '2012-04-25 00:00:00.000000', 802, 101);

-- drop table client;
-- drop table dealer;
-- drop table sell;

select * from dealer join client on dealer.id = client.dealer_id;

select dealer.name, client.name, client.city, client.priority, sell.id, sell.date, sell.amount from dealer inner join client on
dealer.id = client.dealer_id inner join sell on dealer.id = sell.dealer_id and client.id = sell.client_id;

select dealer.id, dealer.name, client.id, client.name, client.city from dealer inner join client on client.city = dealer.location;

select sell.id, sell.amount, client.name, dealer.location from dealer inner join client on dealer.id = client.dealer_id
inner join sell on dealer.id = sell.dealer_id and client.id = sell.client_id where sell.amount >= 100.0 and sell.amount <= 500.0;

select name, id from dealer;

select client.name, client.city, dealer.name, dealer.charge * sell.amount as comission from dealer inner join client on
dealer.id = client.dealer_id inner join sell on dealer.id = sell.dealer_id and client.id = sell.client_id;

select client.name, client.city, dealer.name, dealer.charge * sell.amount as comission from dealer inner join client on dealer.id = client.dealer_id
inner join sell on dealer.id = sell.dealer_id and client.id = sell.client_id where dealer.charge > 0.12;

select client.name, client.city, sell.date, sell.amount, dealer.name, dealer.charge * sell.amount as comission from dealer inner join
client on dealer.id = client.dealer_id inner join sell on dealer.id = sell.dealer_id and client.id = sell.client_id;

select client.name, client.priority, dealer.name, sell.id, sell.amount as temp from dealer inner join client on dealer.id = client.dealer_id
inner join sell on dealer.id = sell.dealer_id and client.id = sell.client_id where sell.amount < 2000 or (sell.amount > 2000
and client.priority is not null);

create view view1 as select sell.date, count(client.name), avg(sell.amount), sum(sell.amount) from sell inner join client
on client.id = sell.client_id group by (sell.date);
select * from view1;

create view view2 as select sell.date, count(client.name), avg(sell.amount), sum(sell.amount) from sell inner join client
on client.id = sell.client_id group by (sell.date) order by sum(-sell.amount);
select * from view2 limit 5;

create view view3 as select dealer.id, count(sell.id), sum(sell.amount), avg(sell.amount) from sell inner join dealer
on dealer.id = sell.dealer_id group by dealer.id;
select * from view3;

create view view4 as select count(sell.dealer_id), sum(sell.amount), avg(sell.amount), sum(sell.amount * dealer.charge) as total from
sell inner join dealer on dealer.id = sell.dealer_id group by dealer.location;
select * from view4;

create view view5 as select dealer.location, count(sell.id), sum(sell.amount) as plus, avg(sell.amount) from sell inner join dealer
on dealer.id = sell.dealer_id group by dealer.location;
select * from view5;

create view view6 as select client.city, count(sell.id), avg(sell.amount), sum(sell.amount) as minus from sell inner join client
on client.id = sell.client_id group by (client.city);
select * from view6;

select * from view5 right join view6 on view5.location = view6.city where view5.plus < view6.minus
or (view5.location is null and view6.city is not null);









