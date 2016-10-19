DROP TABLE ITEM;

CREATE TABLE ITEM (
 itemid VARCHAR(10) NOT NULL,
 productid VARCHAR(10) NOT NULL,
 name VARCHAR(30) NOT NULL,
 description VARCHAR(500) NOT NULL,
 imageurl VARCHAR(155),
 imagethumburl VARCHAR(155),
 price DECIMAL(14,2) NOT NULL,
 primary key (itemid)
);

exit;