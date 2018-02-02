-- MySQL schema
CREATE DATABASE IF NOT EXISTS apache;
use apache;

-- Create tables --
DROP TABLE IF EXISTS mailing_lists;
CREATE TABLE mailing_lists (
    mailing_list_url VARCHAR(255) CHARACTER SET utf8 NOT NULL,
    mailing_list_name VARCHAR(255) CHARACTER SET utf8 NULL DEFAULT 'NULL',
    project_name VARCHAR(255) CHARACTER SET utf8 NULL DEFAULT 'NULL',
    last_analysis DATETIME NULL,
    PRIMARY KEY(mailing_list_url))
ENGINE=INNODB;

DROP TABLE IF EXISTS compressed_files;
CREATE TABLE compressed_files (
    url varchar(255) CHARACTER SET utf8 NOT NULL,
    mailing_list_url varchar(255) CHARACTER SET utf8 not null,
    status enum('new','visited','failed') null,
    last_analysis datetime null,
    primary key(url),
    foreign key(mailing_list_url)
        references mailing_lists(mailing_list_url))
ENGINE=INNODB;

DROP TABLE IF EXISTS people;
CREATE TABLE people (
    email_address VARCHAR(255) CHARACTER SET utf8 NOT NULL,
    name VARCHAR(255) CHARACTER SET utf8 NULL,
    username VARCHAR(255) CHARACTER SET utf8 NULL,
    domain_name VARCHAR(255) CHARACTER SET utf8 NULL,
    top_level_domain VARCHAR(255) CHARACTER SET utf8 NULL,
    PRIMARY KEY(email_address))
ENGINE=INNODB;

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
    message_id VARCHAR(255) CHARACTER SET utf8 NOT NULL,
    mailing_list_url VARCHAR(255) CHARACTER SET utf8 NOT NULL,
    mailing_list VARCHAR(255) CHARACTER SET utf8 NULL,
    first_date DATETIME NULL,
    first_date_tz INTEGER(11) NULL,
    arrival_date DATETIME NULL,
    arrival_date_tz INTEGER(11) NULL,
    subject VARCHAR(1024) CHARACTER SET utf8 NULL,
    message_body MEDIUMTEXT CHARACTER SET utf8mb4 NULL,
    is_response_of VARCHAR(255) CHARACTER SET utf8 NULL,
    mail_path TEXT CHARACTER SET utf8 NULL,
    PRIMARY KEY(message_id, mailing_list_url),
    INDEX response(is_response_of),
    FOREIGN KEY(mailing_list_url)
        REFERENCES mailing_lists(mailing_list_url)
        ON DELETE CASCADE
        ON UPDATE CASCADE)
ENGINE=INNODB;

DROP TABLE IF EXISTS messages_people;
CREATE TABLE messages_people (
    type_of_recipient ENUM('From','To','Cc') NOT NULL DEFAULT 'From',
    message_id VARCHAR(255) CHARACTER SET utf8 NOT NULL,
    mailing_list_url VARCHAR(255) CHARACTER SET utf8 NOT NULL,
    email_address VARCHAR(255) CHARACTER SET utf8 NOT NULL,
    PRIMARY KEY(type_of_recipient, message_id, mailing_list_url, email_address),
    INDEX message_id(message_id, mailing_list_url),
    FOREIGN KEY(message_id, mailing_list_url) REFERENCES messages(message_id, mailing_list_url)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY(email_address) REFERENCES people(email_address)
        ON DELETE CASCADE
        ON UPDATE CASCADE)
ENGINE=INNODB;

DROP TABLE IF EXISTS mailing_lists_people;
CREATE TABLE mailing_lists_people (
    email_address VARCHAR(255) CHARACTER SET utf8 NOT NULL,
    mailing_list_url VARCHAR(255) CHARACTER SET utf8 NOT NULL,
    PRIMARY KEY(email_address, mailing_list_url),
    FOREIGN KEY(mailing_list_url)
        REFERENCES mailing_lists(mailing_list_url)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY(email_address)
        REFERENCES people(email_address)
        ON DELETE CASCADE
        ON UPDATE CASCADE)
ENGINE=INNODB;
