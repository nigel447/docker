drop database lambda_dev;
create database lambda_dev;
\c lambda_dev
CREATE TABLE user_account
(
    Id SERIAL,
    UserName text NOT NULL,
    Email text PRIMARY KEY,
    GUID text,
    PaymentAccount text,
    SortCode text,
    IsProvider text,
    IsAdmin text,
    IsActive text,
    IsNotActiveTime timestamptz
);

CREATE TABLE scheduled_meetings
(
    Id SERIAL PRIMARY KEY,
    Meeting_name text NOT NULL ,
    ModeratorEmail text NOT NULL,
    Thumbnail text,
    Details_Description text,
    DateAndTime timestamptz NOT NULL,
    EndTime timestamptz,
    Price text,
    PayPal_ID text,
    CONSTRAINT FK_ModeratorEmail
      FOREIGN KEY(ModeratorEmail)
	  REFERENCES user_account(Email)
);

-- assume UK Lira
CREATE TABLE Attendee_Payments
(
    Id SERIAL PRIMARY KEY,
    Meeting_Id int references scheduled_meetings(Id),
    Attendee_id text references user_account(email),
    Amount_Paid text,
    VAT_Amount text,
    User_Payment text,
    Commision text,
    Status text,
    StartTime timestamptz,
    PayPal_ID text,
    payer_id text,
    ModeratorEmail text
);

-- assume UK Lira
CREATE TABLE BatchPayments
(
    Id SERIAL,
    ModeratorEmail text references user_account(email),
    Amount_Paid text,
    VAT_Total_Amount text,
    Commision_Total_Amount text,
    PayPal_ID text PRIMARY KEY,
    -- will be unique foe any given email avoids composite key sched meet
    Status text
);

-- assume UK Lira
-- attendee may not have PayPal_ID in system so do not record it here
CREATE TABLE Invoices
(
    Id SERIAL PRIMARY KEY,
    Meeting_Id int references scheduled_meetings(Id),
    Attendee_id text references user_account(email),
    -- payer email
    Price text,
    VAT_Amount text,
    Status text,
    StartTime timestamptz
    --mayby use for its your responsisibility to attend
);

CREATE UNIQUE INDEX no_dupes ON scheduled_meetings (Meeting_name, ModeratorEmail, DateAndTime);

CREATE TABLE on_demand_meetings
(
    Id SERIAL PRIMARY KEY,
    Meeting_name text NOT NULL ,
    ModeratorEmail text NOT NULL,
    GUID text,
    Thumbnail text,
    Details_Description text,
    Video text NOT NULL,
    Price text,
    PayPal_ID text,
    CONSTRAINT FK_ModeratorEmail
      FOREIGN KEY(ModeratorEmail)
	  REFERENCES user_account(Email)
);

CREATE UNIQUE INDEX no_dupes_2 ON on_demand_meetings (Meeting_name, ModeratorEmail, GUID);


CREATE TABLE payment_transaction
(
    Id SERIAL PRIMARY KEY,
    PayerEmail text,
    Meeting_Id int references scheduled_meetings(Id) ,
    -- think of as meeting id from sched meet
    Price text,
    Status text,
    payer_id text,
    TransactionTime timestamptz DEFAULT now(),
    On_Demand_Id int references on_demand_meetings(Id),
    CONSTRAINT FK_PayerEmail
      FOREIGN KEY(PayerEmail)
	  REFERENCES user_account(Email)
);

CREATE TABLE client_payment_status
(
    Id SERIAL PRIMARY KEY,
    PayerEmail text,
    Meeting_Id int references scheduled_meetings(Id) ,
    Status text default 'Attend',
    TransactionTime timestamptz DEFAULT now(),
    On_Demand_Id int references on_demand_meetings(Id),
    CONSTRAINT FK_PayerEmail
      FOREIGN KEY(PayerEmail)
	  REFERENCES user_account(Email)
);



CREATE TABLE live_meetings
(
    Id SERIAL PRIMARY KEY,
    Scheduled_meeting integer not null references scheduled_meetings(Id),
    Meeting_id text,
    Start_time timestamptz DEFAULT now(),
    End_time timestamptz,
    Meeting_name text,
    Meeting_welcome text,
    Moderator_pwd text,
    Attendee_pwd text,
    Record text
);

CREATE TABLE attendees_per_session
(
    Id SERIAL PRIMARY KEY,
    Live_meeting integer not null references live_meetings(Id),
    Attendee_id text references user_account(email),
    UserType text,
    Meeting_id text,
    StartTime timestamptz DEFAULT now(),
    EndTime timestamptz

);

CREATE TABLE attendees_per_demand
(
    Id SERIAL PRIMARY KEY,
    Attendee_id text references user_account(email),
    Meeting_id text
);

-- assume UK Lira
CREATE TABLE OnDemand_Payments
(
    Id SERIAL PRIMARY KEY,
    Meeting_Id int references on_demand_meetings(Id),
    Attendee_id text references user_account(email),
    Amount_Paid text,
    VAT_Amount text,
    User_Payment text,
    Commision text,
    Status text,
    PayPal_ID text,
    payer_id text,
    ModeratorEmail text
);

CREATE TABLE client_request
(
    Id SERIAL PRIMARY KEY,
    Name text,
    Email text,
    Subject text,
    Description text,
    Request_Type text,
    Request_Time timestamptz DEFAULT now()
);



CREATE TABLE provider_details
(
    Id SERIAL PRIMARY KEY,
    Email text,
    Details text,

    CONSTRAINT FK_Email
      FOREIGN KEY(Email)
	  REFERENCES user_account(Email)
);