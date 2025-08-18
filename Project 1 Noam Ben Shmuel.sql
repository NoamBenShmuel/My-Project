create database quiche_and_lovedb --created database
go
use quiche_and_lovedb

create table kitchen_stations (station_id int primary key,
station_name nvarchar (30) not null --created a table specifying the stations in the kitchen and id for easy use in other tables
)
insert kitchen_stations values (1,'hot station')
insert kitchen_stations values (2,'cold station')
insert kitchen_stations values (3,'bakery')

create table menu_categories (category_id int primary key, --created a table naming the categories in the menu and their IDs,
--and to which kitchen station they belong
category_name nvarchar (30) not null, 
station_id int not null references kitchen_stations(station_id)) --created foreign key with kitchen stations table

insert menu_categories values (1,'entrees',1)
insert menu_categories values (2,'salads',2)
insert menu_categories values (3, 'first_course',2)
insert menu_categories values (4, 'soups',1)
insert menu_categories values (5,'side_dishes',2)
insert menu_categories values (6,'quiches',3)
insert menu_categories values (7,'pastries',3)
insert menu_categories values (8, 'desserts',3)

create table menu (dish_id int primary key, --created a table specifying all the dishes in the menu, their price and to which category and kitchen station they belong
dish_name nvarchar (30) not null unique,
category_id int not null references menu_categories (category_id), --created foreign key with menu categories table
dish_price money not null,
station_id int not null references kitchen_stations(station_id)) --created foreign key with kitchen stations table

insert menu values (1,'moroccan tofu', 1,80,1)
insert menu values (2,'artichoke chard', 1,80,1)
insert menu values (3,'aloo gobi',1,75,1)
insert menu values (4,'indonesian curry',1,80,1)
insert menu values (5,'thai curry',1,80,1)
insert menu values (6,'dal makani',1,75,1)
insert menu values (7,'chili non carne', 1,80,1)
insert menu values (8,'quinoam salad',2,70,2)
insert menu values (9,'kholrabi fennel',2,70,2)
insert menu values (10,'lentils yams', 2,65,2)
insert menu values (11,'greek salad',2,70,2)
insert menu values (12,'tabooleh',2,65,2)
insert menu values (13,'caesar salad',2,75,2)
insert menu values (14,'badrijani',3,65,2)
insert menu values (15,'leek patties',3,55,2)
insert menu values (16,'skordalia',3,70,2)
insert menu values (17,'lima massabaha',3,55,1)
insert menu values (18,'spring rolls',3,70,2)
insert menu values (19,'jerus artichoke',4,65,1)
insert menu values (20,'peas',4,60,1)
insert menu values (21,'tomato',4,60,1)
insert menu values (22,'red lentil',4,60,1)
insert menu values (23,'hrira',4,60,1)
insert menu values (24,'onion',4,70,1)
insert menu values (25,'white rice',5,25,1)
insert menu values (26,'brown rice',5,25,1)
insert menu values (27,'mashed potatoes',5,25,1)
insert menu values (28,'baked potatoes',5,25,1)
insert menu values (29,'quinoa',5,35,1)
insert menu values (30,'chard spinach',6,100,3)
insert menu values (31,'mushroom',6,100,3)
insert menu values (32,'leek',6,100,3)
insert menu values (33,'beets yams',6,100,3)
insert menu values (34,'brocolli almonds',6,100,3)
insert menu values (35,'eggplant',6,100,3)
insert menu values (36,'rainbow',6,120,3)
insert menu values (37,'calzone',7,80,3)
insert menu values (38,'burekas',7,80,3)
insert menu values (39,'fatayer',7,75,3)
insert menu values (40,'empanadas',7,80,3)
insert menu values (41,'tiramisu',8,90,3)
insert menu values (42,'cheese cake',8,100,3)
insert menu values (43,'biscuit cake',8,90,3)
insert menu values (44,'orange cake',8,50,3)
insert menu values (45,'banufi',8,50,3)
insert menu values (46,'malabi',8,80,3)
insert menu values (47,'tapioca',8,80,3)

create table employees(employee_id int primary key, --created a table naming all the cooks, in which station they work,
--who is their boss and their birth and hire date
first_name nvarchar (30) not null,
last_name nvarchar (30) not null,
birth_date datetime not null,
hire_date datetime not null,
station_id int references kitchen_stations(station_id), --created foreign key with kitchen stations table
kitchen_boss int references employees(employee_id)) --created a foreign key for employees table with itself

insert employees values (1,'Noam','Ben Shmuel',1980-04-07,2021-01-01,1,null) --Noam's kitchen boss is null because he doesn't have a kitchen boss
insert employees values (2,'Seibo','Traore',1981-02-09,2021-01-12,1,1)
insert employees values (3,'Binyam','Gebru',1986-08-12,2022-01-07,2,1)
insert employees values (4,'Nerya','Kalanterov',1985-02-20,2022-01-18,1,2)
insert employees values (5,'Chen','Weinstein',1977-12-02,2021-03-02,1,2)
insert employees values (6,'Ofer','Lifshitz',1982-12-15,2021-03-15,1,2)
insert employees values (7,'Tal','Dadon',1987-05-13,2021-08-01,2,3)
insert employees values (8,'Orit','Zigdon',1987-03-01,2021-03-16,3,3)
insert employees values (9,'Alon','Arieli',1982-04-28,2022-11-05,1,2)
insert employees values (10,'Sagi','Stolper',1990-12-01,2021-06-06,2,3)
insert employees values (11,'Yifat','Libal',1979-04-10,2021-05-12,1,2)
insert employees values (12,'Roman','Ramon',1989-12-20,2022-11-20,1,2)
insert employees values (13,'Harel','Zakaim',1985-02-01,2022-04-10,1,2)
insert employees values (14,'Gavriel','Hefner',1979-09-23,2021-05-07,3,3)
insert employees values (15,'Israel','Ohayoun',1987-03-13,2021-12-04,3,3)
insert employees values (16,'Adar','Taibi',1990-04-05,2022-06-15,3,3)
insert employees values (17,'Daniel','Mundalk',1987-12-06,2022-03-02,2,3)

create table customers (customer_id int primary key, --created a table with all the customers, whether they a private customer or a company,
--and their contact info
customer_name nvarchar (50) not null,
customer_type nvarchar (30) not null,
delivery_address nvarchar (50),
city nvarchar (30),
phone nvarchar (30) not null unique
)

insert customers values (1,'Dana Azrieli','private','Hayarkon 200','Tel Aviv','052-4837423')
insert customers values (2,'Assaf Amdurski','private','Hameyasdim 42','Ramat Hasharon','054-4876632')
insert customers values (3,'Softshare','company','Habrzel 20','Tel Aviv','054-4599112')
insert customers values (4,'Onpoint','company','Karlibach 16','Tel Aviv','050-5220133')
insert customers values (5,'Efrat Finkelshtein','private','Sirkin 2','Bat Yam','052-7744201')
insert customers values (6,'Quickline','company','Jabotinski 50','Ramat Gan','052-3942211')
insert customers values (7,'Dori Media','company','Habarzel 8','Tel Aviv','054-4703999')
insert customers values (8,'Alona Davidi','private','Harav Kuk 30','Hertzeliya','052-5322934')
insert customers values (9,'Tel Aviv Municipality','company','Ibn Gabirol 66','Tel Aviv','054-4955123')
insert customers values (10,'Strong Gym','company','Hertzel 52','Holon','052-3622966')
insert customers values (11,'Alon Cohen','private','Hashomer 10','Natanya','052-9584991')
insert customers values (12,'Adva Yeshaayahu','private','Katzanelson 60','Givatayim','054-7434155')
insert customers values (13,'Vivian Turgeman','private','Weizman 45','Ashdod','054-5868693')
insert customers values (14,'Booking','company','Begin 144','Tel Aviv','052-6262933')
insert customers values (15,'Vegan Friendly','company','wolfson 12','Tel Aviv','050-5949333')
insert customers values (16,'Yaakov Shalit','private','Haprachim 22','Yavne','054-7633151')
insert customers values (17,'Yael Rosenblum','private','Hatamar 8','Ramat Gan','052-3644464')
insert customers values (18,'Ella Ashurov','private','Tagor 15','Tel Aviv','052-5997383')
insert customers values (19,'Anat Halevi','private','Montifiori 18','Raanana','054-4313555')
insert customers values (20,'John Bryce','company','Homa Umigdal 29','Tel Aviv','054-9522383')


create table deliveries (delivery_id int primary key, --created a table for deliveries info, with order and delivery date,
--whether the delivery is regular or express, and the delivery address (which is not identical to customer address)
customer_id int not null references customers (customer_id), --created foreign key with customers table
order_date datetime not null,
delivery_date datetime not null,
delivery_type nvarchar (30) not null,
delivery_address nvarchar (50) not null,
city nvarchar (30) not null)


insert deliveries values (1, 14, 2023-05-23, 2023-05-30, 'regular', 'Begin 144','Tel Aviv')
insert deliveries values (2, 20, 2022-02-01, 2022-02-06, 'regular', 'Homa Umigdal 29', 'Tel Aviv')
insert deliveries values (3,18,2021-01-02,2021-01-03,'express','Tagor 15','Tel Aviv')
insert deliveries values (4,15,2021-06-30,2021-07-06,'regular','Expo Tel Aviv Hangar 15','Tel Aviv')
insert deliveries values (5,10,2022-04-08,2022-04-15,'regular','Hertzel 52','Holon')
insert deliveries values (6,19,2021-11-11,2021-11-18,'regular','Montifiori 18','Raanana')
insert deliveries values (7,8,2021-02-05,2021-02-06,'express','Harav Kuk 30','Hertzeliya')
insert deliveries values (8,4,2022-07-01,2022-07-06,'regular','Karlibach 16','Tel Aviv')
insert deliveries values (9,2,2023-05-14,2023-05-21,'regular','Hameyasdim 42','Ramat Hasharon')
insert deliveries values (10,6,2022-12-24,2022-12-31,'regular','Jabotinski 50','Ramat Gan') 
insert deliveries values (11,1,2021-03-03,2021-03-10,'regular','Hayarkon 200','Tel Aviv')
insert deliveries values (12,9,2021-03-06,2021-03-20,'regular','Ibn Gabirol 66','Tel Aviv')
insert deliveries values (13,16,2023-08-01,2023-08-03,'express','Haprachim 22','Yavne')
insert deliveries values (14,17,2022-10-22,2022-10-29,'regular','Hatamar 8','Ramat Gan')
insert deliveries values (15,12,2021-05-10,2021-05-12,'express','Katzanelson 60','Givatayim')
insert deliveries values (16,11,2023-02-15,2023-02-22,'regular','Hashomer 10','Natanya')
insert deliveries values (17,3,2022-09-25,2022-10-02,'regular','Habarzel 20','Tel Aviv')
insert deliveries values (18,5,2023-04-06,2023-04-13,'regular','Sirkin 2','Bat Yam')
insert deliveries values (19,7,2021-12-12,2021-12-19,'regular','Habarzel 8','Tel Aviv')
insert deliveries values (20,13,2021-01-05,2021-01-12,'regular','Weizman 45','Ashdod')


create table orders (order_id int primary key, --created a table specifying all the orders together with customer and delivery IDs,
--and where did the order come from
customer_id int not null references customers(customer_id), --created foreign key with customers table
delivery_id int not null references deliveries(delivery_id), --created foreign key with deliveries table
order_source nvarchar (30) not null)

insert orders values (1,14,1,'site')
insert orders values (2,20,2,'app')
insert orders values (3,18,3,'phone')
insert orders values (4,15,4,'app')
insert orders values (5,10,5,'phone')
insert orders values (6,19,6,'site')
insert orders values (7,8,7,'app')
insert orders values (8,4,8,'app')
insert orders values (9,2,9,'phone')
insert orders values (10,6,10,'app')
insert orders values (11,1,11,'site')
insert orders values (12,9,12,'app')
insert orders values (13,16,13,'app')
insert orders values (14,17,14,'phone')
insert orders values (15,12,15,'site')
insert orders values (16,11,16,'site')
insert orders values (17,3,17,'app')
insert orders values (18,5,18,'site')
insert orders values (19,7,19,'app')
insert orders values (20,13,20,'app')

create table order_info (order_id int references orders(order_id), --created a table specifying the details inside each order.
--created foreign key with orders table
dish_id int references menu(dish_id), --crerated foreign key with menu table
primary key (order_id,dish_id), --created a composite primary key so that the combination will be unique
dish_price money not null,	
amount int 	not null)

insert order_details values (1,30,100,2)
insert order_details values (1,31,100,2)
insert order_details values (1,34,100,2)
insert order_details values (1,36,120,2)
insert order_details values (2,14,65,2)
insert order_details values (2,16,70,1)
insert order_details values (2,1,80,2)
insert order_details values (2,9,70,1)
insert order_details values (3,37,80,5)
insert order_details values (3,40,80,5)
insert order_details values (3,12,65,3)
insert order_details values (3,31,100,3)
insert order_details values (4,33,100,3)
insert order_details values (4,35,100,3)
insert order_details values (4,8,70,4)
insert order_details values (4,42,100,3)
insert order_details values (5,25,25,1)
insert order_details values (5,4,80,1)
insert order_details values (6,15,55,4)
insert order_details values (6,18,70,4)
insert order_details values (6,13,65,5)
insert order_details values (6,32,100,3)
insert order_details values (7,10,65,4)
insert order_details values (7,16,70,4)
insert order_details values (7,30,100,3)
insert order_details values (7,41,90,4)
insert order_details values (8,23,60,1)
insert order_details values (8,26,25,1)
insert order_details values (8,6,75,1)
insert order_details values (9,11,70,6)
insert order_details values (9,39,75,6)
insert order_details values (9,2,80,5)
insert order_details values (9,34,100,3)
insert order_details values (10,10,65,4)
insert order_details values (10,29,35,4)
insert order_details values (10,5,80,4)
insert order_details values (10,47,80,2)
insert order_details values (11,20,60,1)
insert order_details values (11,7,80,1)
insert order_details values (12,3,75,2)
insert order_details values (12,45,50,1)
insert order_details values (13,24,70,2)
insert order_details values (13,27,25,1)
insert order_details values (13,2,80,2)
insert order_details values (14,38,80,5)
insert order_details values (14,17,55,5)
insert order_details values (14,19,65,5)
insert order_details values (14,44,50,3)
insert order_details values (15,31,100,3)
insert order_details values (15,33,100,3)
insert order_details values (15,14,65,6)
insert order_details values (15,18,70,6)
insert order_details values (16,21,60,2)
insert order_details values (16,6,75,2)
insert order_details values (17,28,25,1)
insert order_details values (17,1,80,1)
insert order_details values (17,43,90,1)
insert order_details values (18,22,60,2)
insert order_details values (18,9,70,2)
insert order_details values (18,4,80,2)
insert order_details values (19,33,100,1)
insert order_details values (19,46,80,1)
insert order_details values (20,39,75,3)
insert order_details values (20,17,55,4)
insert order_details values (20,12,65,3)
insert order_details values (20,16,70,2)
insert order_details values (20,2,80,3)
insert order_details values (20,25,25,2)
insert order_details values (20,37,80,4)
insert order_details values (20,35,100,2)
insert order_details values (20,41,90,3)

